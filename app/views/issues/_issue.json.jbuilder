json.extract! issue, :id, :projectId, :issueTypeId, :summary, :priorityTypeId, :dueDate, :assignee, :reporter, :environment, :description, :originalEstimate, :remainEstimate, :addedTime
json.url issue_url(issue, format: :json)
