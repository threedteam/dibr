%% base
temp_m = zeros(m_Height, m_Width);
edge = zeros(m_Height, m_Width);
debug = cell(m_Height, m_Width);

% 获取边缘标记
th_d = 20;  %认定为边缘的阈值
temp_e = [rx_d(:, 2:m_Width), rx_d(:, m_Width)];
temp_e = double(temp_e) - double(rx_d);
edge(temp_e > th_d) = 1;
edge(:, 2:m_Width) = edge(:, 1:m_Width-1);
edge(:, 1) = 0;
edge(temp_e < -th_d) = 1;
%% exp1
[u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % 基数为0
u_fix = fix(u_double); v_fix = fix(v_double);
u_round = round(u_double); v_round = round(v_double);

% 判断[u, v]是否落在I1内
InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
if (InIs == 1)% 在才处理
    if tx_m(v_round+1, u_round+1) <= d || temp_m(v_round+1, u_round+1) == 0
        tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
        tx_m(v_round+1, u_round+1) = round(d);
        temp_m(v_round+1, u_round+1) = 1;
    end
    if v_round==v_fix && u_round==u_fix % case 1
        if inpolygon(u_fix+1, v_fix+1, IsXV, IsYV) == 1
            if temp_m(v_fix+2, u_fix+2) == 0
                tx_ides(v_fix+2, u_fix+2, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+2, u_fix+2) = round(d);
            end
        end
    elseif v_round==v_fix+1 && u_round==u_fix+1 % case 2
        if inpolygon(u_fix, v_fix, IsXV, IsYV) == 1
            if temp_m(v_fix+1, u_fix+1) == 0
                tx_ides(v_fix+1, u_fix+1, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+1, u_fix+1) = round(d);
            end
        end
    elseif v_round==v_fix && u_round==u_fix+1 % case 3
        if inpolygon(u_fix, v_fix+1, IsXV, IsYV) == 1
            if temp_m(v_fix+2, u_fix+1) == 0
                tx_ides(v_fix+2, u_fix+1, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+2, u_fix+1) = round(d);
            end
        end
    elseif v_round==v_fix+1 && u_round==u_fix % case 4
        if inpolygon(u_fix+1, v_fix, IsXV, IsYV) == 1
            if temp_m(v_fix+1, u_fix+2) == 0
                tx_ides(v_fix+1, u_fix+2, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+1, u_fix+2) = round(d);
            end
        end
    end
end
%% exp2
[u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % 基数为0
u_fix = fix(u_double); v_fix = fix(v_double);
u_round = round(u_double); v_round = round(v_double);

% 判断[u, v]是否落在I1内
InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
if (InIs == 1)% 在才处理
    if tx_m(v_round+1, u_round+1) <= d
        tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
        tx_m(v_round+1, u_round+1) = round(d);
        temp_m(v_round+1, u_round+1) = 1;
    end
    if v_round==v_fix && u_round==u_fix % case 1
        if inpolygon(u_fix+1, v_fix+1, IsXV, IsYV) == 1
            if temp_m(v_fix+2, u_fix+2) == 0 || (temp_m(v_fix+2, u_fix+2) == 1 && tx_m(v_fix+2, u_fix+2)<d)
                tx_ides(v_fix+2, u_fix+2, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+2, u_fix+2) = round(d);
            end
        end
    elseif v_round==v_fix+1 && u_round==u_fix+1 % case 2
        if inpolygon(u_fix, v_fix, IsXV, IsYV) == 1
            if temp_m(v_fix+1, u_fix+1) == 0 || (temp_m(v_fix+1, u_fix+1) == 1 && tx_m(v_fix+1, u_fix+1)<d)
                tx_ides(v_fix+1, u_fix+1, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+1, u_fix+1) = round(d);
            end
        end
    elseif v_round==v_fix && u_round==u_fix+1 % case 3
        if inpolygon(u_fix, v_fix+1, IsXV, IsYV) == 1
            if temp_m(v_fix+2, u_fix+1) == 0 || (temp_m(v_fix+2, u_fix+1) == 1 && tx_m(v_fix+2, u_fix+1)<d)
                tx_ides(v_fix+2, u_fix+1, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+2, u_fix+1) = round(d);
            end
        end
    elseif v_round==v_fix+1 && u_round==u_fix % case 4
        if inpolygon(u_fix+1, v_fix, IsXV, IsYV) == 1
            if temp_m(v_fix+1, u_fix+2) == 0 || (temp_m(v_fix+1, u_fix+2) == 1 && tx_m(v_fix+1, u_fix+2)<d)
                tx_ides(v_fix+1, u_fix+2, :) = rx_iref(i + 1, j + 1, :);
                tx_m(v_fix+1, u_fix+2) = round(d);
            end
        end
    end
%% exp3
[u_double, v_double] = projXYZtoUV(m_Height, rx_ps, x, y, z); % 基数为0
u_fix = fix(u_double); v_fix = fix(v_double);
u_round = round(u_double); v_round = round(v_double);

% 判断[u, v]是否落在I1内
InIs = inpolygon(u_round, v_round, IsXV, IsYV);  % 1 = True
if (InIs == 1)% 在才处理
    %                         if tx_m(v_round+1, u_round+1) <= d || temp_m(v_round+1, u_round+1) == 0
    if tx_m(v_round+1, u_round+1)<d+th_d
        tx_ides(v_round+1, u_round+1, :) = rx_iref(i + 1, j + 1, :);
        tx_m(v_round+1, u_round+1) = round(d);
        temp_m(v_round+1, u_round+1) = 1;
        debug{v_round+1, u_round+1} = [i+1, j+1];
    end
    if edge(i+1, j+1) == 1
        continue;
    end
    if v_round==v_fix
        v = v_fix+1;
    else
        v = v_fix;
    end
    if u_round==u_fix
        u = u_fix+1;
    else
        u = u_fix;
    end
    if inpolygon(u, v, IsXV, IsYV) == 1
        if temp_m(v+1, u+1) == 0 || (temp_m(v+1, u+1) == 1 && tx_m(v+1, u+1)+th_d<d)
            tx_ides(v+1, u+1, :) = rx_iref(i + 1, j + 1, :);
            tx_m(v+1, u+1) = round(d);
            debug{v+1, u+1} = [i+1, j+1];
        end
    end
end