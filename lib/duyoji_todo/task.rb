#coding: utf-8

require 'active_record'

module DuyojiTodo

	# tasksテーブルを表現するモデルクラスです
	# @author Tsuyoshi Maeda 
	class Task < ActiveRecord::Base

		scope :status_is, ->(status) { where(status: status) }


		NOT_YET = 0 # タスクが完了していない
		DONE    = 1 # タスクが完了した
		PENDING = 2 # 保留状態
		
    # ステータ薄の名称と数値の組み合わせの値
		STATUS = {
		  'NOT_YET' => NOT_YET,
		  'DONE'    => DONE,
      'PENDING' => PENDING
		}.freeze

	end

end
