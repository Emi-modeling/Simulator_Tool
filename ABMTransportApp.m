classdef ABMTransportWebApp < handle
    properties
        UIFigure
        RunButton
        RadKMEditField
        RadKMEditFieldLabel
        GammaSlider
        GammaSliderLabel
        ShareBikeLabel
        CO2Label
    end

    properties (Access = private)
        % Simulation constants
        n = 1000;
        T = 1000;
        md = 10;
        mo = 10;
        beta = 0.01;
        lambda = 0.1;
        alpha_base = 0.55;
        epsilon = 0.01;
        rev = 0.1;
        mu_v = 0;
        rad_km_2017 = 113.0;
        rad_km_2023 = 119.4;
    end

    methods
        function app = ABMTransportWebApp
            app.createComponents();
        end
    end

    methods (Access = private)
        function createComponents(app)
            app.UIFigure = uifigure('Position',[100 100 500 250],'Name','ABM Transport Web App');

            app.RadKMEditFieldLabel = uilabel(app.UIFigure);
            app.RadKMEditFieldLabel.Position = [30 200 180 22];
            app.RadKMEditFieldLabel.Text = 'Bike lanes in 2026 (rad\_km\_2026)';
            app.RadKMEditField = uieditfield(app.UIFigure,'numeric');
            app.RadKMEditField.Position = [220 200 100 22];
            app.RadKMEditField.Value = 130;

            app.GammaSliderLabel = uilabel(app.UIFigure);
            app.GammaSliderLabel.Position = [30 160 180 22];
            app.GammaSliderLabel.Text = 'Gamma (discussion vs observation)';
            app.GammaSlider = uislider(app.UIFigure);
            app.GammaSlider.Position = [220 170 150 3];
            app.GammaSlider.Limits = [0 1];
            app.GammaSlider.Value = 0;

            app.RunButton = uibutton(app.UIFigure,'push');
            app.RunButton.Position = [200 120 120 30];
            app.RunButton.Text = 'Run Simulation';
            app.RunButton.ButtonPushedFcn = @(btn,event) app.runSimulation();

            app.ShareBikeLabel = uilabel(app.UIFigure);
            app.ShareBikeLabel.Position = [30 70 300 22];
            app.ShareBikeLabel.Text = 'Bike share:';

            app.CO2Label = uilabel(app.UIFigure);
            app.CO2Label.Position = [30 40 300 22];
            app.CO2Label.Text = 'Total CO2 (t):';
        end

        function runSimulation(app)
            try
                rad_km_2026 = app.RadKMEditField.Value;
                gamma = app.GammaSlider.Value;

                % --- Load calibration data ---
                opts = delimitedTextImportOptions("NumVariables",18);
                opts.DataLines=[1,Inf]; opts.Delimiter=",";
                opts.VariableNames=["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","B","PNB","NE","EE","Var13","Var14","Var15","Var16","Var17","Var18"];
                opts.SelectedVariableNames=["B","PNB","NE","EE"];
                opts.VariableTypes=["string","string","string","string","string","string","string","string","double","double","double","double","string","string","string","string","string","string"];
                AllData = readtable("AllData.csv",opts);

                B = table2array(AllData(2:end,1));
                PNB = table2array(AllData(2:end,2));
                NE = table2array(AllData(2:end,3));
                clear AllData

                PNB=(PNB-1)/5; B=(B-1)/6; NE=(NE-1)/5;
                data=[B PNB NE]; mu=mean(data); Sigma=cov(data);

                % --- Adjust alpha ---
                pct_change_rad = (rad_km_2026 - app.rad_km_2023) / app.rad_km_2023;
                alpha_sensitivity = 0.5;
                alpha = app.alpha_base * (1 - alpha_sensitivity * pct_change_rad);

                % --- Initialize ---
                init=rmvnrnd(mu,Sigma,app.n,[eye(3);-eye(3)],[ones(3,1);zeros(3,1)]);
                init(:,1)=rand(app.n,1)<init(:,1);

                % --- Run ABM ---
                [x,~,~] = ABM(app.n, app.md, app.mo, app.beta, gamma, app.lambda, alpha, app.epsilon, app.rev, init(:,1), init(:,2), init(:,3), app.mu_v, app.T);
                share_bike = sum(x(:,end))/app.n;

                % --- CO2 calculation ---
                pkm_2023 = struct('walk',4456,'bike',6233,'car',45120,'pp',6769);
                ef = struct('bike',8,'car',144.2,'pp',90.1,'walk',0);

                delta_bike = pkm_2023.bike * share_bike;
                new_bike_pkm = pkm_2023.bike + delta_bike;
                new_car_pkm = max(pkm_2023.car - delta_bike,0);
                new_pp_pkm = pkm_2023.pp;

                co2_bike = new_bike_pkm * ef.bike;
                co2_car  = new_car_pkm * ef.car;
                co2_pp = new_pp_pkm * ef.pp;
                co2_total = co2_bike + co2_car + co2_pp;

                % --- Update outputs ---
                app.CO2Label.Text = sprintf('Total CO2 (t): %.2f', co2_total);
                app.ShareBikeLabel.Text = sprintf('Bike share: %.2f %%', share_bike*100);

            catch ME
                uialert(app.UIFigure, ME.message, 'Simulation Error');
                disp(ME);
            end
        end
    end
end

