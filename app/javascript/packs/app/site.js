var site = {
    getBoards: function (projectId) {
        //console.log(projectId);
        if (projectId) {
            $.ajax({
                type: "GET",
                url: "/issues/" + projectId + "/board_list",
            }).done(function (res) {
                //console.log(res);
                if (res) {
                    let options = '<option value="">Please Select</option>';
                    for (let row of res) {
                        options += '<option value="' + row.id + '">' + row.boardName + '</option>';
                    }
                    $("#issue_boardId").html(options);
                }
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    },
    showCreateIssueModal: function (projectId, boardId) {
        $.ajax({
            type: "GET",
            url: "/issues/" + projectId + "/quick_create",
        }).done(function (res) {
            //console.log(res);
            $("#ajax-issue-form").html(res);
            $("#issue_projectId").val(projectId);
            $("#issue_boardId").val(boardId);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
        $("#exampleModal").modal("show");
    },
    showCreateBoardModal: function (projectId) {
        $.ajax({
            type: "GET",
            url: "/boards/" + projectId + "/quick_create",
        }).done(function (res) {
            //console.log(res);
            $("#ajax-board-form").html(res);
            $("#board_projectId").val(projectId);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
        $("#boardModal").modal("show");
    },
    submitComment: function (issueId) {
        let comment = $('#commentBox').val();
        if ($.trim(comment) != "") {
            $.ajax({
                type: "POST",
                url: "/issues/" + issueId + "/add_comment",
                data: {
                    comment: comment,
                }
            }).done(function (res) {
                $('#commentBox').val("")
                if (res.id) {
                    alert('Comment successfully saved');
                    location.reload();
                }
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    },
    showCheckListModal: function (issueId) {
        $.ajax({
            type: "GET",
            url: "/issue_checklists/" + issueId + "/quick_create",
        }).done(function (res) {
            //console.log(res);
            $("#ajax-chklst-form").html(res);
            $("#issue_checklist_issue_id").val(issueId);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
        $("#checkListModal").modal("show");
    },
    showAttachmentModal: function (issueId) {
        $.ajax({
            type: "GET",
            url: "/issue_images/" + issueId + "/quick_create",
        }).done(function (res) {
            //console.log(res);
            $("#ajax-attachments-form").html(res);
            $("#issue_image_issueId").val(issueId);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
        $("#attachmentsModal").modal("show");
    },
    allowDrop: function (ev) {
        ev.preventDefault();
    },
    drag: function (ev) {
        ev.dataTransfer.setData("text", ev.target.id);
    },
    drop: function (ev, targetBoardId) {
        ev.preventDefault();
        var data = ev.dataTransfer.getData("text");
        ev.target.appendChild(document.getElementById(data));
        var issueId = data.split("-")[1];
        //console.log(targetBoardId);
        //console.log(issueId);
        $.ajax({
            type: "POST",
            url: "/issues/" + issueId + "/move",
            data: {
                boardId: targetBoardId,
            }
        }).done(function (res) {
            console.log(res);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });

    },
    noAllowDrop: function (ev) {
        ev.stopPropagation();
    },
    toggleChecklistCOmpleted: function (issueId, issue_checklist_id) {
        var isChecked = $("#chk-" + issue_checklist_id).is(":checked");
        $.ajax({
            type: "POST",
            url: "/issues/" + issueId + "/complete_checklist",
            data: {
                issue_checklist_id: issue_checklist_id,
                is_checked: (isChecked) ? 1 : 0,
            }
        }).done(function (res) {
            //console.log(res);
            location.reload();
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
    },
    changeIssueStatus: function (type, issueId) {
        $.ajax({
            type: "POST",
            url: "/issues/" + issueId + "/change_status",
            data: {
                type: type,
            }
        }).done(function (res) {
            //console.log(res);
            location.reload();
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
    },
    deleteComment: function (commentId, issueId) {
        var r = confirm('Are you sure?')
        if (r) {
            $.ajax({
                type: "POST",
                url: "/issues/" + issueId + "/delete_comment",
                data: {
                    commentId: commentId,
                }
            }).done(function (res) {
                //console.log(res);
                location.reload();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    },
    deleteAttachment: function (imageId, issueId) {
        var r = confirm('Are you sure?')
        if (r) {
            $.ajax({
                type: "POST",
                url: "/issues/" + issueId + "/delete_attachment",
                data: {
                    imageId: imageId,
                }
            }).done(function (res) {
                //console.log(res);
                location.reload();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    },
    deleteChecklistItem: function (issueCecklistId, issueId) {
        var r = confirm('Are you sure?')
        if (r) {
            $.ajax({
                type: "POST",
                url: "/issues/" + issueId + "/delete_checklist_item",
                data: {
                    issueCecklistId: issueCecklistId,
                }
            }).done(function (res) {
                //console.log(res);
                location.reload();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    },
    addProjectCoordinator:function(projectId){
        $.ajax({
            type: "GET",
            url: "/user_projects/" + projectId + "/quick_create",
        }).done(function (res) {
            //console.log(res);
            $("#ajax-poc-form").html(res);
            $("#user_project_projectId").val(projectId);
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.responseText);
        });
        $("#pocModal").modal("show");
    },
    remProjectCoordinator:function(projectId,userId,id){
        var r = confirm('Are you sure?')
        if (r) {
            $.ajax({
                type: "POST",
                url: "/user_projects/" + id+ "/delete_user",
                data: {
                    projectId: projectId,
                    userId:userId,
                    id:id,
                }
            }).done(function (res) {
                //console.log(res);
                location.reload();
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    }
}
export default site;