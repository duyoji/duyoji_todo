#coding: utf-8

module DuyojiTodo

	# コマンドラインベースの処理を行うクラスです
	# @author Tsuyoshi Maeda 
	class Command

		class << self
			def run(argv)
				new(argv).execute
			end
		end

		def initialize(argv)
			@argv = argv
		end

		def execute
      options     = Options.parse!(@argv)
			sub_command = options.delete(:command)

			#puts options

			DB.prepare

			tasks = case sub_command
							when 'create'
								create_task(options[:name], options[:content])
							when 'delete'
								delete_task(options[:id])
							when 'update'
								update_task(options.delete(options[:id]), options)
							when 'list'
								find_tasks(options[:status])
							end

			p tasks

		rescue => e
			abort "Error: #{e.message}"

		end

		def create_task(name, content)
      # タスク作成時のstatusはデフォルト値が使われNOT_YETとなる
      Task.create!(name: name, content: content).reload
		end

		def delete_task(id)
      task = Task.find(id)
			task.destroy
		end

		def update_task(id, attributes)
			if status_name = attributes[:status]
				attributes[:status] = DuyojiTodo::Task::STATUS.fetch(status_name.upcase)
			end

			task = Task.find(id)
			task.update_attributes! attributes

			task.reload
		end

		def find_tasks(status_name)
			all_tasks = Task.order('created_at DESC')

			if status_name
				status = DuyojiTodo::Task::STATUS.fetch(status_name.upcase)
				all_tasks.status_is(status)
			else
				all_tasks
			end
		end
  
	end

end
