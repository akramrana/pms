var site = {
    getBoards: function (projectId) {
        //console.log(projectId);
        if (projectId) {
            $.ajax({
                type: "GET",
                url: "/issues/" + projectId + "/board_list",
            }).done(function (res) {
                //console.log(res);
                if(res){
                    let options = '<option value="">Please Select</option>';
                    for(let row of res){
                        options += '<option value="'+row.id+'">'+row.boardName+'</option>'; 
                    }
                    $("#issue_boardId").html(options);
                }
            }).fail(function (jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.responseText);
            });
        }
    }
}
export default site;