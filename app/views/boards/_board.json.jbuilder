json.extract! board, :id, :projectId, :boardName, :created_at, :updated_at
json.url board_url(board, format: :json)
