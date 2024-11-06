defmodule Lottery do
  def start_agent do
    Agent.start_link(fn -> %{bets: %{}, counter: 0} end, name: :lottery_state)
  end

  def bet(input) do
    Agent.update(:lottery_state, fn state ->
      counter = state[:counter]

      bets = state[:bets]

      updated_bets = Map.put(bets, counter, input)

      updated_counter = counter + 1

      %{bets: updated_bets, counter: updated_counter}
    end)
  end

  def get_state do
    Agent.get(:lottery_state, fn state -> state end)
  end

  def lottery_draw(limit \\ 60, numbers_to_take \\ 6) do
    Enum.take_random(1..limit, numbers_to_take)
    |> Enum.sort()
  end

  def run do
    x = menu()

    if x == "0" do
      IO.puts("Encerrando...\n")
    else
      run()
    end
  end

  def menu do
    IO.puts("Selecione uma opção")

    option =
      IO.gets("1 - Apostar\n2 - Vencedores\n3 - Histórico\n0 - Encerrar\n")
      |> String.trim()

    case option do
      "1" ->
        input =
          IO.gets("Aposta: ")
          |> String.split(",")
          |> Enum.map(&String.trim(&1))
          |> Enum.map(&String.to_integer(&1))

        bet(input)

        IO.puts("Aposta registrada com sucesso!")
        menu()

      "2" ->
        show_winners()

      "3" ->
        show_history()

      "0" ->
        IO.puts("Encerrando...\n")
        System.halt(0)

      _ ->
        IO.puts("Opção inválida")
        menu()
    end
  end

  def how_much_numbers_are_correct(lottery_list, bet_list) do
    Enum.count(bet_list, fn n -> n in lottery_list end)
  end

  def show_winners do
    lottery_numbers = lottery_draw()

    IO.puts("Sorteio: #{Enum.join(lottery_numbers, ", ")}")

    bets = get_state()[:bets]

    results =
      bets
      |> Enum.map(fn {_, bet} ->
        {bet, how_much_numbers_are_correct(lottery_numbers, bet)}
      end)

    sorted_results = Enum.sort_by(results, fn {_, acertos} -> -acertos end)

    IO.puts("\nRanking das Apostas (ordem de acertos):")

    Enum.each(sorted_results, fn {bet, acertos} ->
      IO.puts("#{Enum.join(bet, ", ")} - Acertos: #{acertos}")
    end)

    menu()
  end

  def show_history do
    bets = get_state()[:bets]

    IO.puts("\nHistórico das Apostas:")

    Enum.each(bets, fn {_, bet} ->
      IO.puts("#{Enum.join(bet, ", ")}")
    end)

    menu()
  end
end
