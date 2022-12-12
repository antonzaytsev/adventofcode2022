describe Day10 do
  subject(:day_class) { described_class.new }

  describe '#part1' do
    subject(:part) { day_class.part1 }

    it { is_expected.to eq 17_020 }

    context 'test data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).and_return("inputs/day10_test.txt")
      end

      it { is_expected.to eq 13_140 }
    end
  end

  describe '#part2' do
    subject(:part) { day_class.part2 }

    let(:output) do
"###..#....####.####.####.#.....##..####.
#..#.#....#.......#.#....#....#..#.#....
#..#.#....###....#..###..#....#....###..
###..#....#.....#...#....#....#.##.#....
#.#..#....#....#....#....#....#..#.#....
#..#.####.####.####.#....####..###.####."
    end
    it { is_expected.to eq output }

    context 'test data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).and_return("inputs/day10_test.txt")
      end

      let(:output) do
        "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."
      end

      it { is_expected.to eq output }
    end
  end

  describe '#part2_letters' do
    subject(:part) { day_class.part2_letters }

    it { is_expected.to eq 'RLEZFLGE' }
  end
end