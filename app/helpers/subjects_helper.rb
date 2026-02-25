module SubjectsHelper
    def status_color_class(topic)
        level = topic.latest_study_log&.understanding_level
        case level
        when "not_understood"
            "bg-gray-100 text-gray-500 border-gray-200"
        when "vaguely_understood"
            "bg-blue-100 text-blue-700 border-blue-200"
        when "understood"
            "bg-green-100 text-green-700 border-green-200"
        when "mastered"
            "animate-shine animate-bounce-short text-yellow-900 border-yellow-500 shadow-yellow-200/50 shadow-lg font-black"
        else
            "bg-white text-gray-400"
        end
    end
end
