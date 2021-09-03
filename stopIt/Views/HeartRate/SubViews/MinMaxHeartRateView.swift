import SwiftUI

struct MinMaxHeartRateView: View {
    var minimumHR: Int
    var maximumHR: Int
    var averageHR: Int
    
    var body: some View {
        ZStack(alignment: .leading){
            Color("heartrate1")
            VStack(alignment: .leading){
                HStack {
                    Text("Minimum")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    Text("\(minimumHR) BPM")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                HStack {
                    Text("Maximum")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(maximumHR) BPM")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                HStack {
                    Text("Average")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(averageHR) BPM")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .frame(width: UIScreen.main.bounds.width - 20, height: 130, alignment: .center)
        .padding([.bottom], 20)
    }
}

struct MinMaxHeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        MinMaxHeartRateView(minimumHR: 60, maximumHR: 145, averageHR: 0)
    }
}
