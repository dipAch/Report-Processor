# Report Processor Class, Build Version 1.0
class Report
	attr_reader :f_handle, :words_in_report # Instance variables for the report to process
	@@check_punctuations = [".", ",", ";", "'", "\"", ":", "#", "@", "!", "%", "(", ")", "?", "/", "<", ">", "{", "}", "[", "]", "|", "\\", "-", "+", "=", "*", "^", "`", "~"] # List class variable for all punctuations, for filtering text
	def initialize(file_handle)
		@f_handle = file_handle # Assign file handle to handler instance variable
		@words_in_report = Hash.new # Text presence and individual frequency count in the report
	end
	
	def process_report
		# Handle Processing
		File.open(@f_handle) do |file_ptr|
			file_ptr.each_line do |line|
				words_parsed = Array.new # Tracks parsed words for each line
				arr_sanitized = line.strip.split.map { |word| strip_punctuations(word) }
				arr_sanitized.each { |stripped_word|
					if !(words_parsed.include?(stripped_word)) then
						if @words_in_report.has_key?(stripped_word) then
							@words_in_report[stripped_word] +=  arr_sanitized.count(stripped_word)
						else
							@words_in_report[stripped_word] = arr_sanitized.count(stripped_word)
						end
						words_parsed << stripped_word
					end
				}
			end
		end
	end
	
	def strip_punctuations(sent_word)
		sanitized_word = sent_word
		@@check_punctuations.each { |punc_char| 
			if sanitized_word.include?(punc_char) then
				sanitized_word = sanitize_word(sanitized_word, punc_char) # Send for further sanitation
			end
		}
		sanitized_word # Return sanitized word
	end
	
	def sanitize_word(impure_word, to_strip)
		last_word_index = impure_word.length - 1
		pure_word = String.new # Get the sanitized word here
		for index in (0..(last_word_index)) do
			if (index == 0 || index == last_word_index) && impure_word[index] == to_strip then
				next
			else
				pure_word += impure_word[index]
			end
		end
		pure_word # Return sanitized[ or pure ] word
	end
end

# Create processing batch (Test batch contains 1 unit[ or report ])
report_model = Report.new("test.txt")
start_time = Time.now # Process started at
report_model.process_report
total_time = Time.now - start_time # Processing time taken
puts "Processing for file: #{report_model.f_handle}"
puts report_model.words_in_report
puts "Time taken to process report (excluding displaying time): #{total_time}"