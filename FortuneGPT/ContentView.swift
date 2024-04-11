import SwiftUI
import OpenAI

// Para minimizar o teclado no iPhone
#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var mageImage: String = "Wizard1"

    let ourOpenAI = OpenAI(apiToken: "sk-...")
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        TextField("Pergunte ao mago", text: $question)
                            .disableAutocorrection(true)
                        
                        Button(action: sendQuestion) {
                            Text("🔮")
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue).frame(maxHeight: 36))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: reset) {
                            Text("🔄")
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue).frame(maxHeight: 36))
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    
                    Image(mageImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(height: 320)
                        
                    
                    Text(answer)
                        .padding()
                        .frame(minHeight: 160, maxHeight: 160)
                }
                .textFieldStyle(.roundedBorder)
            }
            
        }
        .ignoresSafeArea(.keyboard)
    }
    
    func reset() {
        mageImage = "Wizard1"
        answer = ""
        question = ""
    }
    
    func sendQuestion() {
        
        dismissKeyboard()
        
        mageImage = "Wizard2"
        let query = ChatQuery(
            messages: [.init(
                role: .user,
                content: "Responda de maneira sucinta, objetiva, direta e mística como se fosse um vidente mágico: " + question)!],
            model: .gpt3_5Turbo)
        
        ourOpenAI.chats(query: query) { result in
            switch result {
                case .success(let chatResult):
                    let content = chatResult.choices[0].message.content?.string
                    answer = content!
                case .failure(_):
                    answer = "O mago não pode responder no momento"
                }
            mageImage = "Wizard3"
        }
    }

}

#Preview {
    ContentView()
}
