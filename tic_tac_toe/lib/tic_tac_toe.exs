defmodule TicTacToe do
  def run do
    board = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    player_symbol = [" ", "X", "O", "#"]
    player = 0
    last_pos = [[4, 4], [4, 4], [4, 4]]
    last_erased = [false, false, false]

    print_board(board, player_symbol)

    result = game_loop(board, player_symbol, player, last_pos, last_erased)

    if result != nil do
      IO.puts("Parabéns, jogador #{result}")
    else
      IO.puts("Empate")
    end
  end

  defp print_board(board, player_symbol) do
    IO.puts("   0   1   2   3")

    for {row, i} <- Enum.with_index(board) do
      IO.write("#{i} ")

      row_symbols = Enum.map(row, fn x -> Enum.at(player_symbol, x) end)

      row_output =
        " #{Enum.at(row_symbols, 0)} | #{Enum.at(row_symbols, 1)} | #{Enum.at(row_symbols, 2)} | #{Enum.at(row_symbols, 3)} "

      IO.puts(row_output)

      if i < 3 do
        IO.puts("  ---------------")
      end
    end
  end

  defp game_loop(board, player_symbol, player, last_pos, last_erased) do
    IO.write("Rodada do Jogador #{player + 1}!\n")
    IO.puts("Escolha a linha de 0 a 3!")
    line_input = get_valid_input()

    IO.puts("Escolha a coluna de 0 a 3!")
    column_input = get_valid_input()

    if Enum.at(Enum.at(board, line_input), column_input) == player + 1 do
      IO.puts("Você já jogou nessa posição")
      game_loop(board, player_symbol, player, last_pos, last_erased)
    end

    if [line_input, column_input] == Enum.at(last_pos, player) do
      IO.puts("Você não pode se vingar nessa rodada")
      game_loop(board, player_symbol, player, last_pos, last_erased)
    end

    if Enum.at(Enum.at(board, line_input), column_input) != 0 and Enum.at(last_erased, player) do
      IO.puts("Espere uma rodada para apagar o símbolo de outro jogador")
      game_loop(board, player_symbol, player, last_pos, last_erased)
    end

    last_erased =
      List.update_at(last_erased, player, fn _ ->
        Enum.at(Enum.at(board, line_input), column_input)
      end)

    board =
      List.update_at(board, line_input, fn line ->
        List.update_at(line, column_input, fn _ -> player + 1 end)
      end)

    last_pos = List.update_at(last_pos, player, fn _ -> [line_input, column_input] end)

    print_board(board, player_symbol)

    cond do
      get_winner(board) != nil -> get_winner(board)
      is_tie?(board) -> nil
      true -> game_loop(board, player_symbol, rem(player + 1, 3), last_pos, last_erased)
    end
  end

  defp get_valid_input() do
    input = IO.gets("") |> String.trim() |> String.to_integer()

    if input >= 0 and input <= 3 do
      input
    else
      IO.puts("Posição inválida! Escolha novamente, mas um número de 0 a 3")
      get_valid_input()
    end
  end

  defp get_winner(board) do
    cond do
      get_row_winner(board) != nil -> get_row_winner(board)
      get_column_winner(board) != nil -> get_column_winner(board)
      get_diagonal_winner(board) != nil -> get_diagonal_winner(board)
      true -> nil
    end
  end

  defp product(line) do
    Enum.reduce(line, 1, fn x, acc -> acc * x end)
  end

  defp get_row_winner(board) do
    products = Enum.map(board, fn line -> product(line) end)

    cond do
      Enum.member?(products, 1) -> 1
      Enum.member?(products, 16) -> 2
      Enum.member?(products, 81) -> 81
      true -> nil
    end
  end

  defp get_column_winner(board) do
    products =
      for j <- 0..3 do
        Enum.map(board, fn line -> Enum.at(line, j) end)
        |> product()
      end

    cond do
      Enum.member?(products, 1) -> 1
      Enum.member?(products, 16) -> 2
      Enum.member?(products, 81) -> 81
      true -> nil
    end
  end

  defp get_diagonal_winner(board) do
    product1 =
      for i <- 0..3 do
        Enum.at(board, i)
        |> Enum.at(i)
      end
      |> product()

    product2 =
      for i <- 0..3 do
        Enum.at(board, i)
        |> Enum.at(3 - i)
      end
      |> product()

    products = [product1, product2]

    cond do
      Enum.member?(products, 1) -> 1
      Enum.member?(products, 16) -> 2
      Enum.member?(products, 81) -> 81
      true -> nil
    end
  end

  defp is_tie?(board) do
    result = Enum.map(board, fn line -> product(line) end) |> product()
    result != 0
  end
end

TicTacToe.run()
