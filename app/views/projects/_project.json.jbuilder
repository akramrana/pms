json.extract! project, :id, :projectName, :projectKey, :projectLeader, :projectPriority, :projectDetails, :time, :created_at, :updated_at
json.url project_url(project, format: :json)
