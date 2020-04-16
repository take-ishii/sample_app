class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # カラムにインデックスを追加することで検索速度を向上
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # followとfollowedを複合キーインデックス
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
