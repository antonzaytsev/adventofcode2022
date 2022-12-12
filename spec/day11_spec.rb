describe Day11 do
  subject(:day_class) { described_class.new }

  describe '#part1' do
    subject(:part) { day_class.part1 }

    it { is_expected.to eq 110_220 }

    context 'test data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).and_return("inputs/day11_test.txt")
      end

      it { is_expected.to eq 10_605 }
    end
  end

  describe '#part2' do
    subject(:part) { day_class.part2 }

    it { is_expected.to eq 19_457_438_264 }

    context 'test data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).and_return("inputs/day11_test.txt")
      end

      it { is_expected.to eq 2_713_310_158 }
    end
  end
end