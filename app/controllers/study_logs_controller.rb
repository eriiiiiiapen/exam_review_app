class StudyLogsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])

    current_log = @topic.study_logs.order(study_on: :desc, id: :desc).first
    current_level = current_log&.understanding_level || "not_understood"
    next_level = StudyLog.next_level_for(current_level)

    @study_log = @topic.study_logs.build(study_log_params)
    @study_log.user = current_user
    @study_log.understanding_level = next_level

    if @study_log.save
        @topic.reload
        @topic.association(:latest_study_log).reset
        respond_to do |format|
            # create.turbo_stream.erb
            format.turbo_stream
            format.html { redirect_back fallback_location: root_path }
        end
    end
  end

  def create_or_update
    @topic = Topic.find(params[:topic_id])
    @study_log = current_user.study_logs.find_or_initialize_by(topic: @topic)
    
    if @study_log.update(study_log_create_or_update_params)
      @study_log.touch(:study_on)
      respond_to do |format|
        format.turbo_stream
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

  def study_log_create_or_update_params
    params.require(:study_log).permit(:understanding_level, :note)
  end
end
