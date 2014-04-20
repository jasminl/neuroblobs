function event = format_time_series(data)

  event = 1000 * data(:, 6) + 60 * 1000 * data(:, 5) + 60 * 60 * 1000 * data(:, 4);
