classdef proyecto_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        Panel                   matlab.ui.container.Panel
        FilePathEditFieldLabel  matlab.ui.control.Label
        FilePathEditField       matlab.ui.control.EditField
        BrowseButton            matlab.ui.control.Button
        Panel_2                 matlab.ui.container.Panel
        Slider                  matlab.ui.control.Slider
        Slider_2                matlab.ui.control.Slider
        Slider_3                matlab.ui.control.Slider
        Slider_4                matlab.ui.control.Slider
        Slider_5                matlab.ui.control.Slider
        Slider_6                matlab.ui.control.Slider
        Slider_7                matlab.ui.control.Slider
        Slider_8                matlab.ui.control.Slider
        Slider_9                matlab.ui.control.Slider
        Slider_10               matlab.ui.control.Slider
        HzLabel                 matlab.ui.control.Label
        HzLabel_2               matlab.ui.control.Label
        HzLabel_3               matlab.ui.control.Label
        HzLabel_4               matlab.ui.control.Label
        kHzLabel                matlab.ui.control.Label
        kHzLabel_2              matlab.ui.control.Label
        kHzLabel_3              matlab.ui.control.Label
        kHzLabel_4              matlab.ui.control.Label
        kHzLabel_5              matlab.ui.control.Label
        kHzLabel_6              matlab.ui.control.Label
        Label                   matlab.ui.control.Label
        Label_2                 matlab.ui.control.Label
        Label_3                 matlab.ui.control.Label
        Label_4                 matlab.ui.control.Label
        Label_5                 matlab.ui.control.Label
        Label_6                 matlab.ui.control.Label
        Label_7                 matlab.ui.control.Label
        Label_8                 matlab.ui.control.Label
        Label_9                 matlab.ui.control.Label
        Label_10                matlab.ui.control.Label
        Label_11                matlab.ui.control.Label
        Label_12                matlab.ui.control.Label
        Label_13                matlab.ui.control.Label
        ResetFiltersButton      matlab.ui.control.Button
        Panel_3                 matlab.ui.container.Panel
        PlayButton              matlab.ui.control.Button
        PauseButton             matlab.ui.control.Button
        ResumeButton            matlab.ui.control.Button
        StopButton              matlab.ui.control.Button
        FilterButton            matlab.ui.control.Button
        Panel_4                 matlab.ui.container.Panel
        UIAxes                  matlab.ui.control.UIAxes
        UIAxes_2                matlab.ui.control.UIAxes
        Panel_5                 matlab.ui.container.Panel
        PopButton               matlab.ui.control.Button
        RockButton              matlab.ui.control.Button
        PartyButton             matlab.ui.control.Button
        ClassicalButton         matlab.ui.control.Button
    end

    
    properties (Access = public)
        init_path = ""; % Path to open the file dialog
        attenuations = [1 1 1 1 1 1 1 1 1 1];
        y
        Fs
        volume = 1
        processedAudio
        signal
        player
    end
    
    methods (Access = private)
        
        function get_gains(app)
            app.attenuations(1) = app.Slider.Value;
            app.attenuations(2) = app.Slider_2.Value;
            app.attenuations(3) = app.Slider_3.Value;
            app.attenuations(4) = app.Slider_4.Value;
            app.attenuations(5) = app.Slider_5.Value;
            app.attenuations(6) = app.Slider_6.Value;
            app.attenuations(7) = app.Slider_7.Value;
            app.attenuations(8) = app.Slider_8.Value;
            app.attenuations(9) = app.Slider_9.Value;
            app.attenuations(10) = app.Slider_10.Value;
        end
        
        function set_gains(app)
            app.Label_4.Text = num2str(calc_porcentages(app, app.attenuations(1)), 4);
            app.Label_5.Text = num2str(calc_porcentages(app, app.attenuations(2)), 4);
            app.Label_6.Text = num2str(calc_porcentages(app, app.attenuations(3)), 4);
            app.Label_7.Text = num2str(calc_porcentages(app, app.attenuations(4)), 4);
            app.Label_8.Text = num2str(calc_porcentages(app, app.attenuations(5)), 4);
            app.Label_9.Text = num2str(calc_porcentages(app, app.attenuations(6)), 4);
            app.Label_10.Text = num2str(calc_porcentages(app, app.attenuations(7)), 4);
            app.Label_11.Text = num2str(calc_porcentages(app, app.attenuations(8)), 4);
            app.Label_12.Text = num2str(calc_porcentages(app, app.attenuations(9)), 4);
            app.Label_13.Text = num2str(calc_porcentages(app, app.attenuations(10)), 4);
        end
        
        function porcentage = calc_porcentages(~, level)
            porcentage = -100 + (100 * level);
        end
        
        function newAudio = filter_musica(app, rate, attenuations)
            freqBands = [1 200; 201 400; 401 800; 801 1500; 1501 3000;
               3001 5000; 5001 7000; 7001 10000; 10001 15000; 15001 20000];
            audio = app.y(:, 1);
            audiofft = fft(audio, length(audio));
            newfft = audiofft;
            for i=1:length(freqBands) % Iterate through each frequency band
                lower = freqBands(i, 1); upper = freqBands(i, 2);
                newfft = adjustBand(app, newfft, rate, lower, upper, attenuations(i));
            end
        
            % Get new audio file
            newAudio = real(ifft(newfft, length(audio)));
        end
        
        function f = adjustBand(~, fft, rate, low, upp, atten)
            % Attenuate frequencies
            for i=ceil(low/rate*length(fft)):1:ceil(upp/rate*length(fft))
                % Change frequency amplitude on both lower and upper ends of the
                % fft spectrum
                fft(i) = atten*fft(i);
                fft(length(fft)-i) = atten*fft(length(fft)-i);
            end
            % Return modified FFT spectrum
            f = fft;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            [file, path] = uigetfile({'*.mp3';'*.wav'});
            if isequal(file,0)
                app.FilePathEditField.Value = "";
            else
                app.FilePathEditField.Value = fullfile(path,file);
                app.init_path = path;
                [app.y,app.Fs] = audioread(fullfile(path,file));
                %audiofft = fft(app.y, length(app.y));
                %audiofreqs = app.Fs * (0:floor(length(app.y)/2)) / length(app.y);
                %plot(app.UIAxes, audiofreqs, abs(audiofft(1:floor(length(app.y)/2+1))), '-r');
                plot(app.UIAxes, (1:1:length(app.y)), app.y, '-r');
                app.ClassicalButton.Enable = 'on';
                app.RockButton.Enable = 'on';
                app.PopButton.Enable = 'on';
                app.PartyButton.Enable = 'on';
            end
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            global player;
            play(player);
        end

        % Value changed function: Slider, Slider_10, Slider_2, 
        % Slider_3, Slider_4, Slider_5, Slider_6, Slider_7, 
        % Slider_8, Slider_9
        function SliderValueChanged(app, event)
            get_gains(app);
            set_gains(app);
            
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            global player;
            stop(player);
        end

        % Button pushed function: PauseButton
        function PauseButtonPushed(app, event)
            global player;
            pause(player);
        end

        % Button pushed function: ResumeButton
        function ResumeButtonPushed(app, event)
            global player;
            resume(player);
        end

        % Button pushed function: FilterButton
        function FilterButtonPushed(app, event)
            global player
            app.PlayButton.Enable = 'on';
            app.PauseButton.Enable = 'on';
            app.ResumeButton.Enable = 'on';
            app.StopButton.Enable = 'on';
            app.processedAudio = filter_musica(app, app.Fs, app.attenuations);
            %newfft = fft(app.processedAudio, length(app.processedAudio));
            %audiofreqs = app.Fs * (0:floor(length(app.processedAudio)/2)) / length(app.processedAudio);
            %plot(app.UIAxes_2, audiofreqs, abs(newfft(1:floor(length(app.processedAudio)/2+1))), '-r');
            plot(app.UIAxes_2, (1:1:length(app.processedAudio)), app.processedAudio, '-r');
            if (class(player) == "audioplayer")
                stop(player)
            end
            player = audioplayer(app.processedAudio, app.Fs);
        end

        % Button pushed function: ResetFiltersButton
        function ResetFiltersButtonPushed(app, event)
            app.attenuations = [1 1 1 1 1 1 1 1 1 1];
            set_gains(app);
            app.Slider.Value = 1;
            app.Slider_2.Value = 1;
            app.Slider_3.Value = 1;
            app.Slider_4.Value = 1;
            app.Slider_5.Value = 1;
            app.Slider_6.Value = 1;
            app.Slider_7.Value = 1;
            app.Slider_8.Value = 1;
            app.Slider_9.Value = 1;
            app.Slider_10.Value = 1;
        end

        % Button pushed function: PopButton
        function PopButtonPushed(app, event)
            app.attenuations = [0.85 1.39 1.54 1.45 1.09 0.85 0.82 0.79 0.79 0.97];
            set_gains(app);
            app.Slider.Value = app.attenuations(1);
            app.Slider_2.Value = app.attenuations(2);
            app.Slider_3.Value = app.attenuations(3);
            app.Slider_4.Value = app.attenuations(4);
            app.Slider_5.Value = app.attenuations(5);
            app.Slider_6.Value = app.attenuations(6);
            app.Slider_7.Value = app.attenuations(7);
            app.Slider_8.Value = app.attenuations(8);
            app.Slider_9.Value = app.attenuations(9);
            app.Slider_10.Value = app.attenuations(10);
            FilterButtonPushed(app, event);
        end

        % Button pushed function: RockButton
        function RockButtonPushed(app, event)
            app.attenuations = [1.45 0.64 0.44 0.73 1.79 1.4 1.25 1.22 1.22 1.19];
            set_gains(app);
            app.Slider.Value = app.attenuations(1);
            app.Slider_2.Value = app.attenuations(2);
            app.Slider_3.Value = app.attenuations(3);
            app.Slider_4.Value = app.attenuations(4);
            app.Slider_5.Value = app.attenuations(5);
            app.Slider_6.Value = app.attenuations(6);
            app.Slider_7.Value = app.attenuations(7);
            app.Slider_8.Value = app.attenuations(8);
            app.Slider_9.Value = app.attenuations(9);
            app.Slider_10.Value = app.attenuations(10);
            FilterButtonPushed(app, event);
        end

        % Button pushed function: PartyButton
        function PartyButtonPushed(app, event)
            app.attenuations = [1.54 1 1 1 1 1 1 1 1 1.54];
            set_gains(app);
            app.Slider.Value = app.attenuations(1);
            app.Slider_2.Value = app.attenuations(2);
            app.Slider_3.Value = app.attenuations(3);
            app.Slider_4.Value = app.attenuations(4);
            app.Slider_5.Value = app.attenuations(5);
            app.Slider_6.Value = app.attenuations(6);
            app.Slider_7.Value = app.attenuations(7);
            app.Slider_8.Value = app.attenuations(8);
            app.Slider_9.Value = app.attenuations(9);
            app.Slider_10.Value = app.attenuations(10);
            FilterButtonPushed(app, event);
        end

        % Button pushed function: ClassicalButton
        function ClassicalButtonPushed(app, event)
            app.attenuations = [1 1 1 1 1 1 0.97 0.43 0.4 0.19];
            set_gains(app);
            app.Slider.Value = app.attenuations(1);
            app.Slider_2.Value = app.attenuations(2);
            app.Slider_3.Value = app.attenuations(3);
            app.Slider_4.Value = app.attenuations(4);
            app.Slider_5.Value = app.attenuations(5);
            app.Slider_6.Value = app.attenuations(6);
            app.Slider_7.Value = app.attenuations(7);
            app.Slider_8.Value = app.attenuations(8);
            app.Slider_9.Value = app.attenuations(9);
            app.Slider_10.Value = app.attenuations(10);
            FilterButtonPushed(app, event);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1180 515];
            app.UIFigure.Name = 'MATLAB App';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Position = [13 447 613 48];

            % Create FilePathEditFieldLabel
            app.FilePathEditFieldLabel = uilabel(app.Panel);
            app.FilePathEditFieldLabel.HorizontalAlignment = 'right';
            app.FilePathEditFieldLabel.Position = [17 13 56 22];
            app.FilePathEditFieldLabel.Text = 'File Path:';

            % Create FilePathEditField
            app.FilePathEditField = uieditfield(app.Panel, 'text');
            app.FilePathEditField.Editable = 'off';
            app.FilePathEditField.Position = [88 13 412 22];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.Panel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [510 13 67 22];
            app.BrowseButton.Text = 'Browse';

            % Create Panel_2
            app.Panel_2 = uipanel(app.UIFigure);
            app.Panel_2.Position = [15 142 609 295];

            % Create Slider
            app.Slider = uislider(app.Panel_2);
            app.Slider.Limits = [0 2];
            app.Slider.MajorTicks = [];
            app.Slider.Orientation = 'vertical';
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.MinorTicks = [];
            app.Slider.Position = [39 77 7 185];
            app.Slider.Value = 1;

            % Create Slider_2
            app.Slider_2 = uislider(app.Panel_2);
            app.Slider_2.Limits = [0 2];
            app.Slider_2.MajorTicks = [];
            app.Slider_2.Orientation = 'vertical';
            app.Slider_2.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_2.MinorTicks = [];
            app.Slider_2.Position = [99 77 7 185];
            app.Slider_2.Value = 1;

            % Create Slider_3
            app.Slider_3 = uislider(app.Panel_2);
            app.Slider_3.Limits = [0 2];
            app.Slider_3.MajorTicks = [];
            app.Slider_3.Orientation = 'vertical';
            app.Slider_3.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_3.MinorTicks = [];
            app.Slider_3.Position = [159 77 7 185];
            app.Slider_3.Value = 1;

            % Create Slider_4
            app.Slider_4 = uislider(app.Panel_2);
            app.Slider_4.Limits = [0 2];
            app.Slider_4.MajorTicks = [];
            app.Slider_4.Orientation = 'vertical';
            app.Slider_4.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_4.MinorTicks = [];
            app.Slider_4.Position = [219 77 7 185];
            app.Slider_4.Value = 1;

            % Create Slider_5
            app.Slider_5 = uislider(app.Panel_2);
            app.Slider_5.Limits = [0 2];
            app.Slider_5.MajorTicks = [];
            app.Slider_5.Orientation = 'vertical';
            app.Slider_5.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_5.MinorTicks = [];
            app.Slider_5.Position = [279 77 7 185];
            app.Slider_5.Value = 1;

            % Create Slider_6
            app.Slider_6 = uislider(app.Panel_2);
            app.Slider_6.Limits = [0 2];
            app.Slider_6.MajorTicks = [];
            app.Slider_6.Orientation = 'vertical';
            app.Slider_6.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_6.MinorTicks = [];
            app.Slider_6.Position = [339 77 7 185];
            app.Slider_6.Value = 1;

            % Create Slider_7
            app.Slider_7 = uislider(app.Panel_2);
            app.Slider_7.Limits = [0 2];
            app.Slider_7.MajorTicks = [];
            app.Slider_7.Orientation = 'vertical';
            app.Slider_7.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_7.MinorTicks = [];
            app.Slider_7.Position = [399 77 7 185];
            app.Slider_7.Value = 1;

            % Create Slider_8
            app.Slider_8 = uislider(app.Panel_2);
            app.Slider_8.Limits = [0 2];
            app.Slider_8.MajorTicks = [];
            app.Slider_8.Orientation = 'vertical';
            app.Slider_8.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_8.MinorTicks = [];
            app.Slider_8.Position = [459 77 7 185];
            app.Slider_8.Value = 1;

            % Create Slider_9
            app.Slider_9 = uislider(app.Panel_2);
            app.Slider_9.Limits = [0 2];
            app.Slider_9.MajorTicks = [];
            app.Slider_9.Orientation = 'vertical';
            app.Slider_9.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_9.MinorTicks = [];
            app.Slider_9.Position = [519 77 7 185];
            app.Slider_9.Value = 1;

            % Create Slider_10
            app.Slider_10 = uislider(app.Panel_2);
            app.Slider_10.Limits = [0 2];
            app.Slider_10.MajorTicks = [];
            app.Slider_10.Orientation = 'vertical';
            app.Slider_10.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider_10.MinorTicks = [];
            app.Slider_10.Position = [579 77 7 185];
            app.Slider_10.Value = 1;

            % Create HzLabel
            app.HzLabel = uilabel(app.Panel_2);
            app.HzLabel.FontSize = 10;
            app.HzLabel.Position = [21 261 43 22];
            app.HzLabel.Text = '0-200Hz';

            % Create HzLabel_2
            app.HzLabel_2 = uilabel(app.Panel_2);
            app.HzLabel_2.FontSize = 10;
            app.HzLabel_2.Position = [76 261 54 22];
            app.HzLabel_2.Text = '201-400Hz';

            % Create HzLabel_3
            app.HzLabel_3 = uilabel(app.Panel_2);
            app.HzLabel_3.FontSize = 10;
            app.HzLabel_3.Position = [136 261 54 22];
            app.HzLabel_3.Text = '401-800Hz';

            % Create HzLabel_4
            app.HzLabel_4 = uilabel(app.Panel_2);
            app.HzLabel_4.FontSize = 10;
            app.HzLabel_4.Position = [196 261 60 22];
            app.HzLabel_4.Text = '801-1500Hz';

            % Create kHzLabel
            app.kHzLabel = uilabel(app.Panel_2);
            app.kHzLabel.FontSize = 10;
            app.kHzLabel.Position = [260 261 46 22];
            app.kHzLabel.Text = '1.5-3kHz';

            % Create kHzLabel_2
            app.kHzLabel_2 = uilabel(app.Panel_2);
            app.kHzLabel_2.FontSize = 10;
            app.kHzLabel_2.Position = [324 261 37 22];
            app.kHzLabel_2.Text = '3-5kHz';

            % Create kHzLabel_3
            app.kHzLabel_3 = uilabel(app.Panel_2);
            app.kHzLabel_3.FontSize = 10;
            app.kHzLabel_3.Position = [384 261 37 22];
            app.kHzLabel_3.Text = '5-7kHz';

            % Create kHzLabel_4
            app.kHzLabel_4 = uilabel(app.Panel_2);
            app.kHzLabel_4.FontSize = 10;
            app.kHzLabel_4.Position = [441 261 43 22];
            app.kHzLabel_4.Text = '7-10kHz';

            % Create kHzLabel_5
            app.kHzLabel_5 = uilabel(app.Panel_2);
            app.kHzLabel_5.FontSize = 10;
            app.kHzLabel_5.Position = [499 261 48 22];
            app.kHzLabel_5.Text = '10-15kHz';

            % Create kHzLabel_6
            app.kHzLabel_6 = uilabel(app.Panel_2);
            app.kHzLabel_6.FontSize = 10;
            app.kHzLabel_6.Position = [563 261 40 22];
            app.kHzLabel_6.Text = '>15kHz';

            % Create Label
            app.Label = uilabel(app.Panel_2);
            app.Label.Position = [1 158 30 22];
            app.Label.Text = '+0%';

            % Create Label_2
            app.Label_2 = uilabel(app.Panel_2);
            app.Label_2.Position = [1 77 40 22];
            app.Label_2.Text = '-100%';

            % Create Label_3
            app.Label_3 = uilabel(app.Panel_2);
            app.Label_3.Position = [1 240 43 22];
            app.Label_3.Text = '+100%';

            % Create Label_4
            app.Label_4 = uilabel(app.Panel_2);
            app.Label_4.BackgroundColor = [0.8 0.8 0.8];
            app.Label_4.HorizontalAlignment = 'center';
            app.Label_4.Position = [21 39 43 29];
            app.Label_4.Text = '0';

            % Create Label_5
            app.Label_5 = uilabel(app.Panel_2);
            app.Label_5.BackgroundColor = [0.8 0.8 0.8];
            app.Label_5.HorizontalAlignment = 'center';
            app.Label_5.Position = [81 39 43 29];
            app.Label_5.Text = '0';

            % Create Label_6
            app.Label_6 = uilabel(app.Panel_2);
            app.Label_6.BackgroundColor = [0.8 0.8 0.8];
            app.Label_6.HorizontalAlignment = 'center';
            app.Label_6.Position = [141 39 43 29];
            app.Label_6.Text = '0';

            % Create Label_7
            app.Label_7 = uilabel(app.Panel_2);
            app.Label_7.BackgroundColor = [0.8 0.8 0.8];
            app.Label_7.HorizontalAlignment = 'center';
            app.Label_7.Position = [204 39 43 29];
            app.Label_7.Text = '0';

            % Create Label_8
            app.Label_8 = uilabel(app.Panel_2);
            app.Label_8.BackgroundColor = [0.8 0.8 0.8];
            app.Label_8.HorizontalAlignment = 'center';
            app.Label_8.Position = [261 39 43 29];
            app.Label_8.Text = '0';

            % Create Label_9
            app.Label_9 = uilabel(app.Panel_2);
            app.Label_9.BackgroundColor = [0.8 0.8 0.8];
            app.Label_9.HorizontalAlignment = 'center';
            app.Label_9.Position = [321 39 43 29];
            app.Label_9.Text = '0';

            % Create Label_10
            app.Label_10 = uilabel(app.Panel_2);
            app.Label_10.BackgroundColor = [0.8 0.8 0.8];
            app.Label_10.HorizontalAlignment = 'center';
            app.Label_10.Position = [381 39 43 29];
            app.Label_10.Text = '0';

            % Create Label_11
            app.Label_11 = uilabel(app.Panel_2);
            app.Label_11.BackgroundColor = [0.8 0.8 0.8];
            app.Label_11.HorizontalAlignment = 'center';
            app.Label_11.Position = [441 39 43 29];
            app.Label_11.Text = '0';

            % Create Label_12
            app.Label_12 = uilabel(app.Panel_2);
            app.Label_12.BackgroundColor = [0.8 0.8 0.8];
            app.Label_12.HorizontalAlignment = 'center';
            app.Label_12.Position = [501 39 43 29];
            app.Label_12.Text = '0';

            % Create Label_13
            app.Label_13 = uilabel(app.Panel_2);
            app.Label_13.BackgroundColor = [0.8 0.8 0.8];
            app.Label_13.HorizontalAlignment = 'center';
            app.Label_13.Position = [561 39 43 29];
            app.Label_13.Text = '0';

            % Create ResetFiltersButton
            app.ResetFiltersButton = uibutton(app.Panel_2, 'push');
            app.ResetFiltersButton.ButtonPushedFcn = createCallbackFcn(app, @ResetFiltersButtonPushed, true);
            app.ResetFiltersButton.Position = [259 7 93 22];
            app.ResetFiltersButton.Text = 'Reset Filters';

            % Create Panel_3
            app.Panel_3 = uipanel(app.UIFigure);
            app.Panel_3.Position = [16 75 609 56];

            % Create PlayButton
            app.PlayButton = uibutton(app.Panel_3, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Enable = 'off';
            app.PlayButton.Position = [15 17 100 22];
            app.PlayButton.Text = 'Play';

            % Create PauseButton
            app.PauseButton = uibutton(app.Panel_3, 'push');
            app.PauseButton.ButtonPushedFcn = createCallbackFcn(app, @PauseButtonPushed, true);
            app.PauseButton.Enable = 'off';
            app.PauseButton.Position = [136 17 100 22];
            app.PauseButton.Text = 'Pause';

            % Create ResumeButton
            app.ResumeButton = uibutton(app.Panel_3, 'push');
            app.ResumeButton.ButtonPushedFcn = createCallbackFcn(app, @ResumeButtonPushed, true);
            app.ResumeButton.Enable = 'off';
            app.ResumeButton.Position = [255 17 100 22];
            app.ResumeButton.Text = 'Resume';

            % Create StopButton
            app.StopButton = uibutton(app.Panel_3, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Enable = 'off';
            app.StopButton.Position = [381 17 100 22];
            app.StopButton.Text = 'Stop';

            % Create FilterButton
            app.FilterButton = uibutton(app.Panel_3, 'push');
            app.FilterButton.ButtonPushedFcn = createCallbackFcn(app, @FilterButtonPushed, true);
            app.FilterButton.Position = [499 17 96 22];
            app.FilterButton.Text = 'Filter';

            % Create Panel_4
            app.Panel_4 = uipanel(app.UIFigure);
            app.Panel_4.Position = [663 10 490 485];

            % Create UIAxes
            app.UIAxes = uiaxes(app.Panel_4);
            title(app.UIAxes, 'Original')
            xlabel(app.UIAxes, '# of sample')
            ylabel(app.UIAxes, 'Amplitude')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [25 261 439 190];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.Panel_4);
            title(app.UIAxes_2, 'FIltered')
            xlabel(app.UIAxes_2, '# of sample')
            ylabel(app.UIAxes_2, 'Amplitude')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Position = [25 29 439 190];

            % Create Panel_5
            app.Panel_5 = uipanel(app.UIFigure);
            app.Panel_5.Position = [16 12 609 50];

            % Create PopButton
            app.PopButton = uibutton(app.Panel_5, 'push');
            app.PopButton.ButtonPushedFcn = createCallbackFcn(app, @PopButtonPushed, true);
            app.PopButton.Enable = 'off';
            app.PopButton.Position = [77 13 98 22];
            app.PopButton.Text = 'Pop';

            % Create RockButton
            app.RockButton = uibutton(app.Panel_5, 'push');
            app.RockButton.ButtonPushedFcn = createCallbackFcn(app, @RockButtonPushed, true);
            app.RockButton.Enable = 'off';
            app.RockButton.Position = [197 13 98 22];
            app.RockButton.Text = 'Rock';

            % Create PartyButton
            app.PartyButton = uibutton(app.Panel_5, 'push');
            app.PartyButton.ButtonPushedFcn = createCallbackFcn(app, @PartyButtonPushed, true);
            app.PartyButton.Enable = 'off';
            app.PartyButton.Position = [317 13 98 22];
            app.PartyButton.Text = 'Party';

            % Create ClassicalButton
            app.ClassicalButton = uibutton(app.Panel_5, 'push');
            app.ClassicalButton.ButtonPushedFcn = createCallbackFcn(app, @ClassicalButtonPushed, true);
            app.ClassicalButton.Enable = 'off';
            app.ClassicalButton.Position = [440 14 98 22];
            app.ClassicalButton.Text = 'Classical';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = proyecto_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end