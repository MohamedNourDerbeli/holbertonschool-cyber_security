#!/usr/bin/env ruby
require 'optparse'
require 'fileutils'

# File where tasks will be stored
TASKS_FILE = 'tasks.txt'

# Ensure the tasks file exists, create it if not
FileUtils.touch(TASKS_FILE)

# Method to list tasks
def list_tasks
  tasks = File.readlines(TASKS_FILE).map(&:chomp)
  if tasks.empty?
    puts "No tasks available."
  else
    tasks.each_with_index do |task, index|
      puts "#{index + 1}. #{task}"
    end
  end
end

# Method to add a task
def add_task(task)
  File.open(TASKS_FILE, 'a') { |file| file.puts(task) }
  puts "Task '#{task}' added."
end

# Method to remove a task by index
def remove_task(index)
  tasks = File.readlines(TASKS_FILE).map(&:chomp)
  if index.to_i.between?(1, tasks.size)
    removed_task = tasks.delete_at(index.to_i - 1)
    File.open(TASKS_FILE, 'w') { |file| file.puts(tasks) }
    puts "Task '#{removed_task}' removed."
  else
    puts "Invalid task index."
  end
end

# CLI options and argument parsing
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:remove] = index
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

# Perform actions based on options
if options[:add]
  add_task(options[:add])
elsif options[:list]
  list_tasks
elsif options[:remove]
  remove_task(options[:remove])
else
  puts "Invalid option. Use -h for help."
end
