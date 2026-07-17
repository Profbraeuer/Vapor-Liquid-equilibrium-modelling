function [handles, x, y] = ternaryPlot(ax,A, B, C, varargin)

    if nargin < 3
        C = 1 - (A+B);
    end
    
    [varargin, majors] = extractpositional(varargin, 'majors', 10);
    [varargin, sortpoints] = extractpositional(varargin, 'sortpoints', false);
    
    [fA, fB, fC] = fractions(A, B, C);
    
    [x, y] = terncoords(fA, fB, fC);
    
    if sortpoints
        [x, i] = sort(x);
        y = y(i);
    end
    
    [hold_state, ax, next] = ternaxes(ax,majors);
    
    % plot data
    q = plot(ax,x, y, varargin{:});
    if nargout > 0
        handles = q;
    end
    
    set(ax,'dataaspectratio',[1 1 1]);
end

%% Helper FUNCTIONS
function [hold_state, ax, next] = ternaxes(ax,majors)
    if nargin < 1
        majors = 10;
    end
    
    next = lower(get(ax,'NextPlot'));
    hold_state = ishold(ax);
    
    tc = [0.5 0.5 0.5];
    
    fAngle  = get(ax, 'DefaultTextFontAngle');
    fName   = get(ax, 'DefaultTextFontName');
    fSize   = get(ax, 'DefaultTextFontSize');
    fWeight = get(ax, 'DefaultTextFontWeight');
    fUnits  = get(ax, 'DefaultTextUnits');
    
    set(ax, 'DefaultTextFontAngle',  get(ax, 'FontAngle'), ...
             'DefaultTextFontName',   get(ax, 'FontName'), ...
             'DefaultTextFontSize',   get(ax, 'FontSize'), ...
             'DefaultTextFontWeight', get(ax, 'FontWeight'), ...
             'DefaultTextUnits','data')
    
    if ~hold_state
    
        % plot background 
        if ~ischar(get(ax,'color'))
           patch(ax,'xdata', [0 1 0.5 0], 'ydata', [0 0 sin(1/3*pi) 0], ...
                 'edgecolor',tc,'facecolor',get(ax,'color'));
        end
    
        %plot axis lines
	    hold(ax,'on');
	    plot (ax,[0 1 0.5 0],[0 0 sin(1/3*pi) 0], 'color', tc, 'linewidth',3);
	    set(ax,'visible','off');
        
        majorticks = linspace(0, 1, majors + 1); 
        majorticks = majorticks(1:end-1);
        
        labels = num2str([majorticks,1]','%.1f');
            
        zerocomp = zeros(size(majorticks));
        
	    % Plot bottom labels
        [lxc, lyc] = terncoords(1-majorticks, majorticks, zerocomp);
	    text(ax,[lxc,1], [lyc,0]+0.008, [repmat('  ', length(labels), 1) labels],"FontSize",30);

	    % Plot left labels 
        [lxb, lyb] = terncoords(majorticks, zerocomp, 1-majorticks); % fB = 1-fA
	    text(ax,[lxb,0.5]-0.055, [lyb,0.866]+0.03, labels, 'VerticalAlignment', 'Top',"FontSize",30);
    
	    % Plot right labels 
	    [lxa, lya] = terncoords(zerocomp, 1-majorticks, majorticks);
	    text(ax,[lxa, 0]-0.015, [lya, 0]-0.03, labels,"FontSize",30);
    
	    nlabels = length(labels)-2;
	    for i = 1:nlabels
            plot(ax,[lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], 'color', tc, 'linewidth',0.5);
            plot(ax,[lxb(i+1) lxc(nlabels - i + 2)], [lyb(i+1) lyc(nlabels - i + 2)], 'color', tc, 'linewidth',0.5);
            plot(ax,[lxc(i+1) lxa(nlabels - i + 2)], [lyc(i+1) lya(nlabels - i + 2)], 'color', tc, 'linewidth',0.5);
        end

    end
    
    set(ax, 'DefaultTextFontAngle', fAngle , ...
        'DefaultTextFontName',   fName , ...
        'DefaultTextFontSize',   fSize, ...
        'DefaultTextFontWeight', fWeight, ...
        'DefaultTextUnits', fUnits );
end
%%
function [remainingargs, value] = extractpositional(args, name, default)
    remainingargs = {};
    skipping = false;
    value = default;
    for i = 1:length(args)
        if strcmp(args{i}, name)
            value = args{i+1};
            skipping = true;
        elseif skipping
            skipping = false;
        else
            remainingargs{end+1} = args{i};
        end
    end
end


function [fA, fB, fC] = fractions(A, B, C)
    Total = (A+B+C);
    fA = A./Total;
    fB = B./Total;
    fC = 1-(fA+fB);
end


function [x, y] = terncoords(fA, fB, fC)
    if nargin < 3
        fB = 1 - (fA + fC);
    end
    y = fA*sin(deg2rad(60));
    x = fB + y*cot(deg2rad(60));
end