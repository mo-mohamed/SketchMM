defmodule Sketch.Repo.Migrations.CreateShape do
  use Ecto.Migration

  def up do
    drop_if_exists(table(:shape))

    create table(:shape, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:meta_data, :map)
      add(:type, :string)
      add(:canvas_id, references(:canvas, on_delete: :delete_all, type: :binary_id))
    end
  end
end
