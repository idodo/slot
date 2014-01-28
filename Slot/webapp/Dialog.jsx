var Dialog = {
    showing : false,
    show : function(title, content){
        $('dialog-title').innerHTML = title;
        $('dialog-content').innerHTML = content;
        document.body.className = 'show-dialog';
    },
    hide : function(){
        $('dialog-title').innerHTML = '';
        $('dialog-content').innerHTML = '';
        document.body.className = '';
    }
};

Hammer($('dialog-close')).on('tap', Dialog.hide);