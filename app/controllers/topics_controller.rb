class TopicsController < ApplicationController
  def index
    @subjects = Subject.includes(topics: [:study_logs, :tags]).all
    @title = "学習ダッシュボード"
  end

  def new
    @subject = Subject.find(params[:subject_id])
    @topic = @subject.topics.build
    render layout: false
  end

  def create
    @subject = Subject.find(params[:subject_id])
    @topic = @subject.topics.build(topic_params)

    if @topic.save
      respond_to do |format|
        format.turbo_stream # create.turbo_stream.erb
        format.html { redirect_to @subject, notice: '論点を追加しました' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @topic = Topic.find(params[:id])
    @subject = @topic.subject
    render layout: false
  end

  def update
    @topic = Topic.find(params[:id])
    @subject = @topic.subject

    if @topic.update(topic_params)
      respond_to do |format|
        # update.turbo_stream.erb
        format.turbo_stream
        format.html { redirect_to topics_path }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      # destroy.turbo_stream.erb
      format.turbo_stream 
      format.html { redirect_to topics_path, notice: "論点を削除しました" }
    end
  end

  def search
    @tag_name = params[:tag_name]
      
    if @tag_name.present?
      @topics = Topic.joins(:tags)
                    .where(tags: { name: @tag_name })
                    .includes(:subject, :tags, :study_logs)
      @grouped_topics = @topics.group_by(&:subject)
    else
      redirect_to topics_path, alert: "検索ワードを入力してください"
    end
  end

  def import
    if params[:file].present?
      Topic.import_csv!(params[:file])
      redirect_to topics_path, notice: "論点をインポートしました。"
    else
      redirect_to topics_path, alert: "ファイルを選択してください。"
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :tag_list)
  end
end
