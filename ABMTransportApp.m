classdef ABMTransportWebApp < handle
    properties
        UIFigure
        RunButton
        RadKMEditField
        RadKMEditFieldLabel
        FahrradzhlerinderStadtButton
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
        epsilon = 0.01;
        rev = 0.1;
        rad_km_2023 = 90.4;
        gamma = 0;
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

            % Create FahrradzhlerinderStadtButton
            app.FahrradzhlerinderStadtButton = uibutton(app.GridLayout, 'push');
            app.FahrradzhlerinderStadtButton.ButtonPushedFcn = createCallbackFcn(app, @FahrradzhlerinderStadtButtonPushed, true);
            app.FahrradzhlerinderStadtButton.BackgroundColor = [1 0.9098 0.3922];
            app.FahrradzhlerinderStadtButton.FontWeight = 'bold';
            app.FahrradzhlerinderStadtButton.Layout.Row = 3;
            app.FahrradzhlerinderStadtButton.Layout.Column = 2;
            app.FahrradzhlerinderStadtButton.Text = 'Fahrradzähler in der Stadt';

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

        % Button pushed function: FahrradzhlerinderStadtButton
        function FahrradzhlerinderStadtButtonPushed(app, event)
                app.UIFigure.UserData.mu_v = 0.5;
                uialert(app.UIFigure, ...
        'Fahrradzähler in der Stadt aufgestellt (mu_v = 0.5)', ...
        'Information');
        end

        function runSimulation(app)
            try
                rad_km_2026 = app.RadKMEditField.Value;
            if isfield(app.UIFigure.UserData, 'mu_v')
                mu_v = app.UIFigure.UserData.mu_v;
            else
                mu_v = 0;
            end
               

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

                % --- Set alpha ---
                alpha = -((rad_km_2026 - 500).^3) / 250000000 + 0.5;

                % --- Initialize ---
                init=rmvnrnd(mu,Sigma,app.n,[eye(3);-eye(3)],[ones(3,1);zeros(3,1)]);
                init(:,1)=rand(app.n,1)<init(:,1);

                % --- Run ABM ---
                [x,~,~] = ABM(app.n, app.md, app.mo, app.beta, gamma, app.lambda, alpha, app.epsilon, app.rev, init(:,1), init(:,2), init(:,3), app.mu_v, app.T);
                share_bike = sum(x(:,end))/app.n;

                % --- CO2 calculation ---
                pkm_2023 = struct('walk',4456,'bike',6233,'car',45120,'pp',6769);
                ef = struct('bike',8,'car',144.2,'pp',90.1,'walk',0);

                co2_time = zeros(1, T);

                % baseline
                co2_base = pkm_2023.bike*ef.bike + pkm_2023.car*ef.car + pkm_2023.pp*ef.pp;

                for t = 1:T
                bike_share_t = sum(x(:,t))/n;
                new_bike_pkm = pkm_2023.bike * (1 + bike_share_t);
                delta_bike_t = new_bike_pkm - pkm_2023.bike;
                new_car_pkm = max(pkm_2023.car - delta_bike_t, 0);
                new_pp_pkm = pkm_2023.pp;

                co2_total_t = new_bike_pkm*ef.bike + new_car_pkm*ef.car + new_pp_pkm*ef.pp;
                co2_time(t) = 100 * (1 - (co2_total_t / co2_base)); % in percent
        end

                % Final CO₂ emissions and labels
                co2_final = co2_time(end);
                app.EinwohnendedieFahrradfahrenLabel.Text = sprintf('Einwohnende, \ndie Fahrrad fahren: %.2f %%', share_bike*100);
                app.CO2ReduktionimVergleichzumJahr2023Label.Text = sprintf(['CO2 Reduktion im Vergleich\n zum Jahr 2023: %.1f %%'], co2_final);

                % --- Plot bike behavior over time ---
                plot(app.UIAxes, 1:T, sum(x)/n, 'b', 'LineWidth', 2);
                title(app.UIAxes, 'Fahrradnutzung über Zeit');
                xlabel(app.UIAxes, 'Zeit');
                ylabel(app.UIAxes, 'Anteil Fahrradfahrer');
                grid(app.UIAxes, 'on');

                % --- Plot CO₂ emissions over time (% baseline) ---
                plot(app.UIAxes2, 1:T, co2_time, 'g', 'LineWidth', 2);
                title(app.UIAxes2, 'CO₂-Emissionen Reduktion (% im Vergleich zu 2023)');
                xlabel(app.UIAxes2, 'Zeit');
                ylabel(app.UIAxes2, 'CO₂ [%]');
                grid(app.UIAxes2, 'on');

            catch ME
                uialert(app.UIFigure, ME.message, 'Simulation Error');
                disp(ME);
            end
        end
    end
end



