var Sound = {
    audio : null,
    playing : false,
    init : function(){
        if(!this.audio){
            var sound = new Audio('bg.mp3');
            sound.loop = true;
            sound.preload = 'auto';
            //sound.autoplay = true;
            sound.load();
            this.audio = sound;
            var btn = $('sound');
            if(localStorage.getItem('sound') != 'off'){
                this.play();
            } else {
                btn.className = 'off';
            }
            Hammer(btn).on('tap', this.toggle.bind(this));
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
    toggle : function(){
        if(this.playing){
            this.pause();
        } else {
            this.play();
        }
    }
};