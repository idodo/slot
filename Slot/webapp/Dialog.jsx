var Dialog = {
    showing : false,
    show : function(title, content, buttons){
        $('dialog-title').innerHTML = title;
        $('dialog-content').innerHTML = content;
        $('dialog-buttons').innerHTML = buttons || '';
        document.body.className = 'show-dialog';
    },
    hide : function(){
        $('dialog-title').innerHTML = '';
        $('dialog-content').innerHTML = '';
        $('dialog-buttons').innerHTML = '';
        document.body.className = '';
    }
};

Hammer($('dialog-close')).on('tap', Dialog.hide);