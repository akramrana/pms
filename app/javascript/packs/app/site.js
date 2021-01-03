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
    }
}
export default site;