describe Day15 do
  subject(:day_class) { described_class.new }

  describe '#part1' do
    subject(:part) { day_class.part1(target_y) }

    let(:target_y) { 2_000_000 }

    it { is_expected.to eq 5_100_463 }

    context 'sample data' do
      let(:target_y) { 10 }

      before do
        allow(day_class).to receive(:input_local_file_for_day).
          and_return("inputs/day#{described_class.name.gsub(/\D+/, '')}_sample.txt")
      end

      it { is_expected.to eq 26 }
    end
  end

  describe '#part2' do
    subject(:part) { day_class.part2(search_area) }

    let(:search_area) { [0, 4_000_000] }

    it { is_expected.to eq 11_557_863_040_754 }

    context 'sample data' do
      let(:search_area) { [0, 20] }
      before do
        allow(day_class).to receive(:input_local_file_for_day).
          and_return("inputs/day#{described_class.name.gsub(/\D+/, '')}_sample.txt")
      end

      it { is_expected.to eq 56_000_011 }
    end
  end
end
