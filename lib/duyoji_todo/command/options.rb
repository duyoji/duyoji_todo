#coding: utf-8

require "optparse"

module DuyojiTodo

	class Command

		module Options

			def self.parse!(argv)
				options = {}

				# サブコマンドなどのOptionParserを定義
				sub_command_parsers = create_sub_command_parsers(options)
				command_parser      = create_command_parser


				# 引数解析を行う
				begin
					command_parser.order!(argv)
					options[:command] = argv.shift
					sub_command_parsers[ options[:command] ].parse!(argv)

					#updateとdeleteの場合は
					if %w(update delete).include?( options[:command] )
						raise ArgumentError, "#{options[:command]} id not found." if argv.empty?
						options[:id] = Integer(argv.first)
					end
				rescue OptionParser::MissingArgument =>  e
					abort "OptionParserMissingArgument : #{e.message}"
				rescue OptionParser::InvalidOption =>  e
					abort "OptionParserInvalidOption : #{e.message}"
				rescue ArgumentError =>  e
					abort "ArgumentError : #{e.message}"
				end

				options
			end

			def self.create_sub_command_parsers(options)
				# サブコマンドの処理をする際に、未定義のkeyを指定されたら例外を発生させる
				sub_command_parsers = Hash.new do |k, v|
					raise ArgumentError, "'#{v}' is not duyoji_todo sub command."
				end

				# サブコマンド用の定義
				sub_command_parsers['create'] = OptionParser.new do |opt|
					opt.banner = "Usage: create <args>"
					opt.on('-n', '--name=VAL',    'task name')     { |v| options[:name]    = v }
					opt.on('-c', '--content=VAL', 'task content')  { |v| options[:content] = v }
					opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
				end

				sub_command_parsers['list'] = OptionParser.new do |opt|
					opt.banner = "Usage: list <args>"
					opt.on('-s', '--status=VAL',    'search status') { |v| options[:status] = v }
					opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
				end

				sub_command_parsers['update'] = OptionParser.new do |opt|
					opt.banner = "Usage: update id <args>"
					opt.on('-n', '--name=VAL',    'update name')    { |v| options[:name]    = v }
					opt.on('-c', '--content=VAL', 'update content') { |v| options[:content] = v }
					opt.on('-s', '--status=VAL',  'update status')  { |v| options[:status] = v }
					opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
				end

				sub_command_parsers['delete'] = OptionParser.new do |opt|
					opt.banner = "Usage: delete id"
					opt.on_tail('-h', '--help', 'Show this message') { |v| help_sub_command(opt) }
				end

				sub_command_parsers
			end

			def self.create_command_parser
				# サブコマンド以外の定数の定義
				OptionParser.new do |opt|
					sub_command_help = [
					  {name: 'create -n name -c content',              summary: 'Create Todo Task'},
					  {name: 'update id -n name -c content -s status', summary: 'Update Todo Task'},
					  {name: 'list   -s status',                       summary: 'List   Todo Task'},
					  {name: 'delete id',                              summary: 'Delete Todo Task'},
					]

					opt.banner = "Usage: #{opt.program_name} [-h|--help] [-v|--version] <command> [<args>]"
					opt.separator ''
					opt.separator "#{opt.program_name} Available Commands:"
					
					sub_command_help.each do |command|
					  opt.separator [ opt.summary_indent, command[:name].ljust(40), command[:summary] ].join(' ')
					end

					opt.on_head('-h', '--help', 'Show this version') do |v|
						puts opt.help
						exit
					end

					opt.on_head('-v', '--version', 'Show program version') do |v|
						opt.version = DuyojiTodo::VERSION
						puts opt.ver
						exit
					end
				end
			end

			# サブコマンドのヘルプ情報
			def self.help_sub_command(parser)
				puts parser.help
				exit
			end

			private_class_method :create_sub_command_parsers, :create_command_parser, :help_sub_command
		end
		
	end

end
