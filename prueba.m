            %[file, path] = uigetfile(strcat('*.wav'));
            %[file, path] = uigetfile(strcat('*.wav'));
            finame = '/home/atorr55/Downloads/BAD BUNNY x ROSALÍA - LA NOCHE DE ANOCHE EL ÚLTIMO TOUR DEL MUNDO [Visualizer].wav';
            [y, Fs] = audioread(finame);
            cut_off=200;
            orde=16;
            a=fir1(orde,cut_off/(Fs/2),'low');
            y1=-5*filter(a,1,y);
            
            % %bandpass1
            f1=201;
            f2=400;
            b1=fir1(orde,[f1/(Fs/2) f2/(Fs/2)],'bandpass');
            y2=-5*filter(b1,1,y);
            % 
            % %bandpass2
            f3=401;
            f4=800;
            b2=fir1(orde,[f3/(Fs/2) f4/(Fs/2)],'bandpass');
            y3=-5*filter(b2,1,y);
            % 
            % %bandpass3
            f4=801;
            f5=1500;
            b3=fir1(orde,[f4/(Fs/2) f5/(Fs/2)],'bandpass');
            y4=-5*filter(b3,1,y);
            % 
            % %bandpass4
            f5=1501;
            f6=3000;
            b4=fir1(orde,[f5/(Fs/2) f6/(Fs/2)],'bandpass');
            y5=-5*filter(b4,1,y);
            % 
            % %bandpass5
            f7=3001;
            f8=5000;
            b5=fir1(orde,[f7/(Fs/2) f8/(Fs/2)],'bandpass');
            y6=-5*filter(b5,1,y);
            % 
            % %bandpass6
            f9=5001;
            f10=7000;
            b6=fir1(orde,[f9/(Fs/2) f10/(Fs/2)],'bandpass');
            y7=-5*filter(b6,1,y);
            % 
            % %bandpass7
            f11=7001;
            f12=10000;
            b7=fir1(orde,[f11/(Fs/2) f12/(Fs/2)],'bandpass');
            y8=8*filter(b7,1,y);
            % 
             % %bandpass8
            f13=10001;
            f14=15000;
            b8=fir1(orde,[f13/(Fs/2) f14/(Fs/2)],'bandpass');
            y9=9*filter(b8,1,y);
            % 
             %highpass
            cut_off2=15000;
            c=fir1(orde,cut_off2/(Fs/2),'high');
            y10=10*filter(c,1,y);
            yf=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;