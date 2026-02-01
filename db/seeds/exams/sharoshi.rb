puts "Seeding exam （社労士用）"

exam = Exam.find_or_create_by!(
  name: "社労士",
  description: "社会保険労務士試験"
)

subjects_with_topics = {
  "労働基準法" => [
    "労働条件の明示",
    "解雇予告",
    "変形労働時間制",
    "割増賃金"
  ],
  "健康保険法" => [
    "被保険者の資格取得",
    "被扶養者の範囲",
    "傷病手当金",
  ],
  "厚生年金保険法" => [
    "被保険者区分",
    "老齢厚生年金",
    "遺族厚生年金"
  ]
}

subjects_with_topics.each do |subject_name, topic_names|
  subject = exam.subjects.find_or_create_by!(name: subject_name)

  topic_names.each do |topic_name|
    subject.topics.find_or_create_by!(name: topic_name)
  end
end

puts "Seeding exam （社労士用） completed"
