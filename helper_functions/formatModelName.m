function name = formatModelName(model_name)

switch string(model_name)

    case "uniquac_gl"
        name = "UNIQUAC-gl";

    case "uniquac_sep"
        name = "UNIQUAC-sep";

    case "nrtl"
        name = "NRTL";

    otherwise
        name = upper(string(model_name));

end

end