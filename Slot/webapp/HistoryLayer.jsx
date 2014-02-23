var HistoryLayer = View.derive({
    setHistoryList : function(data){
        var html = [];
        if(data && data.length){
//            var n = 20; while(n--)
            data.forEach(function(item){
                var li  = '<time>' + item.createdAt.replace(/^\d+\-|:\d+\.\d+$/g, '') + '</time>';
                    li += '<span class="comment">' + item.comment + '</span>';
                    li += '<span class="status">' + item.status + '</span>';
                html.push(li);
            });
        } else {
            html.push('暂无兑换记录');
        }
        $('history-list').innerHTML = '<li>' + html.join('</li><li>') + '</li>'
    }
});