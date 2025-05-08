#!/usr/bin/env ruby

require 'optparse'

class TaskManager
  TASKS_FILE = 'tasks.txt'

  def initialize
    @tasks = File.exist?(TASKS_FILE) ? File.readlines(TASKS_FILE).map(&:chomp) : []
  end

  def add(task)
    @tasks << task
    save_tasks
    puts "Task '#{task}' added."
  end

  def list
    @tasks.each_with_index do |task, index|
      puts "#{index + 1}. #{task}"
    end
  end

  def remove(index)
    if index.between?(1, @tasks.size)
      removed_task = @tasks.delete_at(index - 1)
      save_tasks
      puts "Task '#{removed_task}' removed."
    else
      puts "Invalid index. Please provide a number between 1 and #{@tasks.size}."
    end
  end

  private

  def save_tasks
    File.write(TASKS_FILE, @tasks.join("\n"))
  end
end

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
    options[:remove] = index.to_i
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

task_manager = TaskManager.new

if options[:add]
  task_manager.add(options[:add])
elsif options[:list]
  task_manager.list
elsif options[:remove]
  task_manager.remove(options[:remove])
else
  puts "No option provided. Use -h for help."
end
