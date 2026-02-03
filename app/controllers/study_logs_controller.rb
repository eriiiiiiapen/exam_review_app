class StudyLogsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])

    current_log = @topic.study_logs.order(study_on: :desc, id: :desc).first
    current_level = current_log&.understanding_level || "not_understood"
    next_level = next_understanding_level(current_level)

    @study_log = @topic.study_logs.build(study_log_params)
    # TODO:ログイン機能追加後
    # @study_log.user = current_user
    @study_log.user = User.first
    @study_log.understanding_level = next_level

    if @study_log.save
        @topic.reload
        @topic.association(:latest_study_log).reset
        respond_to do |format|
            format.turbo_stream {
                render turbo_stream: turbo_stream.replace(
                "topic_#{@topic.id}_status",
                partial: "subjects/status_button",
                locals: { topic: @topic }
                )
            }
            format.html { redirect_back fallback_location: root_path }
        end
    end
  end

  private

  def next_understanding_level(current)
    levels = StudyLog.understanding_levels.keys
    current_index = levels.index(current.to_s) || -1
    next_index = current_index + 1
    next_index = 0 if next_index >= levels.size
    levels[next_index]
  end

  def study_log_params
    params.require(:study_log).permit(:study_on)
  end
end
