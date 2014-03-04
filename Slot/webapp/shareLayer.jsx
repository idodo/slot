var ShareLayer = View.derive({
    init : function(){
    Hammer($('share-infos')).on('tap', function (evt) {
            var tag = evt.target.tagName.toLocaleLowerCase();
            if (tag === 'ul') return;
            var li = tag === 'span' ? evt.target.parentNode : evt.target;
            NSLog('category ' + li.getAttribute('share-type'));
            var shareType = li.getAttribute('share-type');
            switch( shareType ){
            case 'tuijian':
                Director.show('tuijian'); break;
            case 'guanzhu':
                Director.show('guanzhu'); break;
            case '5star':
                Director.show('5star'); break;
            case 'install':
                Director.show('install'); break;
            case 'weixin':
                Director.show('weixin'); break;
            }
    });

    },
    setShareList: function (infos) {
        if (infos && infos.length) {
            var html = '';
            infos.forEach(function (item) {
                var attr = [
                    'share-type="' + item.type + '"'
                ].join(' ');
                html += '<li ' + attr + '>';
                html += '<span>' + item.title + '</span>';
                html += '<span>' + item.earn + '</span>';
                html += '</li>';
            });
            $('share-infos').innerHTML = html;
        }
    }

});