import SwiftUI

struct CardView: View {
    var contents1: String
    var contents2: String
    var contents3: String
    var imageName: String
    
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    Text(contents1)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(contents2)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(contents3.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
                
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .frame(width: UIScreen.main.bounds.width - 20)
        .padding([.top, .horizontal])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(contents1: "My Study Place", contents2: "오늘은 어디서 공부를 할까?", contents3: "나의 공부장소 입력하러 가기", imageName: "study2")
    }
}
