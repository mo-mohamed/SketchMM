defmodule Sketch.Repo.Migrations.CreateCanvas do
  use Ecto.Migration

  def up do
    drop_if_exists(table(:canvas))

    create table(:canvas, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:matrix, :map)
      add(:meta_data, :map)
      add(:type, :string)
    end
  end

  def down do

  end
end
