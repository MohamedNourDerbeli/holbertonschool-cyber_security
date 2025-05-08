#!/usr/bin/env ruby
require 'optparse'

TASKS_FILE = 'tasks.txt'
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on('-a', '--add TASK', 'Add a new task') do |task|
    options[:add] = task
  end

  opts.on('-l', '--list', 'List all tasks') do
    options[:list] = true
  end

  opts.on('-r', '--remove INDEX', Integer, 'Remove a task by index') do |index|
    options[:remove] = index
  end

  opts.on('-h', '--help', 'Show help') do
    puts opts
    exit
  end
end.parse!

# Ensure the tasks file exists
File.write(TASKS_FILE, '', mode: 'a')

tasks = File.readlines(TASKS_FILE, chomp: true)

if options[:add]
  tasks << options[:add]
  File.write(TASKS_FILE, tasks.join("\n") + "\n")
  puts "Task '#{options[:add]}' added."

elsif options[:list]
  puts "Tasks:"
  tasks.each_with_index do |task, index|
    puts "#{index + 1}. #{task}"
  end

elsif options[:remove]
  index = options[:remove] - 1
  if index >= 0 && index < tasks.length
    removed = tasks.delete_at(index)
    File.write(TASKS_FILE, tasks.join("\n") + "\n")
    puts "Task '#{removed}' removed."
  else
    puts "Invalid task index."
  end

elsif options.empty?
  puts "Use -h or --help for usage."
end
