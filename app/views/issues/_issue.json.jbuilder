json.extract! issue, :id, :projectId, :issueTypeId, :summary, :prioritypeId, :dueDate, :assignee, :reporter, :environment, :description, :originalEstimate, :remainEstimate, :addedTime, :created_at, :updated_at
json.url issue_url(issue, format: :json)
