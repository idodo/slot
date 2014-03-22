var Sound = {
    audio : null,
    playing : false,
    init : function(){
        var btn = $('sound');
        if(this.audio){
            this.audio.pause();
        } else {
            Hammer(btn).on('tap', this.toggle.bind(this));
        }
        this.playing = false;
        var sound = new Audio('bg.mp3');
        sound.loop = true;
        sound.preload = 'auto';
        //sound.autoplay = true;
        sound.load();
        this.audio = sound;
        if(localStorage.getItem('sound') != 'off'){
            this.play();
        } else {
            btn.className = 'off';
        }
    },
    play : function(){
        if(!this.playing){
            this.audio.play();
            this.playing = true;
            $('sound').className = '';
            localStorage.setItem('sound', 'on');
        }
    },
    pause : function(){
        if(this.playing){
            this.audio.pause();
            this.playing = false;
            $('sound').className = 'off';
            localStorage.setItem('sound', 'off');
        }
    },
    win : function(){
        if(localStorage.getItem('sound') != 'off'){
            var audio = new Audio('win2.wav');
            audio.loop = false;
            audio.autoplay = true;
            audio.load();
        }
    },
    go : function(){
        if(localStorage.getItem('sound') != 'off'){
            var audio = new Audio('go.wav');
            audio.loop = false;
            audio.autoplay = true;
            audio.load();
        }
    },
    toggle : function(){
        if(this.playing){
            this.pause();
        } else {
            this.play();
        }
    }
};