#!/usr/bin/env ruby
require 'optparse'
require 'fileutils'

TASKS_FILE = 'tasks.txt'

# Ensure the file exists
FileUtils.touch(TASKS_FILE)

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", Integer, "Remove a task by index") do |index|
    options[:remove] = index
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

tasks = File.readlines(TASKS_FILE, chomp: true)

if options[:add]
  if tasks.include?(options[:add])
    puts "Task '#{options[:add]}' already exists."
  else
    tasks << options[:add]
    File.write(TASKS_FILE, tasks.join("\n") + "\n")
    puts "Task '#{options[:add]}' added."
  end
elsif options[:list]
  puts "Tasks:"
  tasks.each_with_index do |task, index|
    puts "#{index + 1}. #{task}"
  end
elsif options[:remove]
  index = options[:remove].to_i
  if index >= 1 && index <= tasks.size
    removed = tasks.delete_at(index - 1)
    File.write(TASKS_FILE, tasks.join("\n") + "\n")
    puts "Task '#{removed}' removed."
  else
    puts "Invalid task index."
  end
else
  puts "Usage: cli.rb [options]"
  puts "    -a, --add TASK                   Add a new task"
  puts "    -l, --list                       List all tasks"
  puts "    -r, --remove INDEX               Remove a task by index"
  puts "    -h, --help                       Show help"
end
