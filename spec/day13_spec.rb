describe Day13 do
  subject(:day_class) { described_class.new }

  describe '#part1' do
    subject(:part) { day_class.part1 }

    it { is_expected.to eq 5_366 }

    context 'sample data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).
          and_return("inputs/day#{described_class.name.gsub(/\D+/, '')}_sample.txt")
      end

      it { is_expected.to eq 13 }
    end
  end

  describe '#part2' do
    subject(:part) { day_class.part2 }

    it { is_expected.to eq 23_391 }

    context 'sample data' do
      before do
        allow(day_class).to receive(:input_local_file_for_day).
          and_return("inputs/day#{described_class.name.gsub(/\D+/, '')}_sample.txt")
      end

      it { is_expected.to eq 140 }
    end
  end
end