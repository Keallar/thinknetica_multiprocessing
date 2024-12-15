require 'async'

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  next filename if File.exist?(filename)

  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

# puts Sequentially
def process_files_sequentially(files)
  files.each do |file|
    File.open(file, 'r') do |f|
      f.each_line { |line| puts line }
    end
  end
end

def process_files_threads(files)
  threads = files.map do |file|
    Thread.new do
      File.open(file, 'r') do |f|
        f.each_line { |line| puts line }
      end
    end
  end
  threads.each(&:join)
end

def process_files_async(files)
  Async do |task|
    files.each do |file|
      task.async do
        File.open(file, 'r') do |f|
          f.each_line { |line| puts line }
        end
      end
    end
  end
end

start_time_sequentially = Time.now
process_files_sequentially(files)
end_time_sequentially = Time.now

start_time_threads = Time.now
process_files_threads(files)
end_time_threads = Time.now

start_time_async = Time.now
process_files_async(files)
end_time_async = Time.now

puts "Время выполнения Sequentially: #{end_time_sequentially - start_time_sequentially} секунд" # Время выполнения Sequentially: 1.253316 секунд
puts "Время выполнения Threads: #{end_time_threads - start_time_threads} секунд" # Время выполнения Threads: 2.746106 секунд
puts "Время выполнения Async: #{end_time_async - start_time_async} секунд" # Время выполнения Async: 1.176041 секунд
