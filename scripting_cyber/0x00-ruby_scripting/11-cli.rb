#!/usr/bin/env ruby
require 'optparse'
require 'fileutils'

TASKS_FILE = 'tasks.txt'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on('-a', '--add=TASK', 'Add a new task') do |task|
    options[:add] = task
  end

  opts.on('-l', '--list', 'List all tasks') do
    options[:list] = true
  end

  opts.on('-r', '--remove=INDEX', Integer, 'Remove a task by index') do |index|
    options[:remove] = index
  end

  opts.on('-h', '--help', 'Show help') do
    puts opts
    exit
  end
end.parse!

# Ensure the tasks file exists
FileUtils.touch(TASKS_FILE)

if options[:add]
  File.open(TASKS_FILE, 'a') { |f| f.puts(options[:add]) }
  puts "Task '#{options[:add]}' added."
elsif options[:list]
  tasks = File.readlines(TASKS_FILE, chomp: true)
  puts "Tasks:"
  tasks.each_with_index do |task, index|
    puts "#{index + 1}. #{task}"
  end
elsif options[:remove]
  tasks = File.readlines(TASKS_FILE, chomp: true)
  index = options[:remove] - 1
  if index.between?(0, tasks.length - 1)
    removed_task = tasks.delete_at(index)
    File.open(TASKS_FILE, 'w') { |f| f.puts(tasks) }
    puts "Task '#{removed_task}' removed."
  else
    puts "Invalid index: #{options[:remove]}"
  end
else
  puts "No option provided. Use -h for help."
end
