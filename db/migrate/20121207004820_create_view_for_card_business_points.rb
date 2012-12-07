class CreateViewForCardBusinessPoints < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute <<-SQL
    CREATE VIEW card_points AS
      SELECT  
        ca.id AS card_id, 
        b.id AS business_id,
        SUM(c.points) AS total_points, 
        COALESCE((SELECT SUM(co.points) FROM coupons co JOIN benefits be ON be.id = co.benefit_id WHERE co.card_id = c.id AND be.business_id = b.id), 0) AS benefit_points,
        SUM(c.points) - COALESCE((SELECT SUM(co.points) FROM coupons co JOIN benefits be ON be.id = co.benefit_id WHERE co.card_id = c.id AND be.business_id = b.id),0) AS points
      FROM cards ca
        JOIN checkins c ON c.card_id = ca.id
        JOIN businesses b ON b.id = c.business_id
      GROUP BY
        ca.id, b.id
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<-SQL
      DROP VIEW card_points
    SQL
  end
end
