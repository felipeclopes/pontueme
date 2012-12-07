class CreateViewsForUserBusinessPoints < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW user_points AS
      SELECT  
        u.id AS user_id, 
        b.id AS business_id,
        SUM(c.points) AS total_points, 
        COALESCE((SELECT SUM(co.points) FROM coupons co JOIN benefits be ON be.id == co.benefit_id WHERE co.user_id = u.id AND be.business_id = b.id), 0) AS benefit_points,
        SUM(c.points) - COALESCE((SELECT SUM(co.points) FROM  coupons co JOIN benefits be ON be.id == co.benefit_id WHERE co.user_id = u.id AND be.business_id = b.id),0) AS points
      FROM users u
        JOIN checkins c ON c.user_id = u.id
        JOIN businesses b ON b.id = c.business_id
      GROUP BY
        u.id, b.id
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW user_points
    SQL
  end
end