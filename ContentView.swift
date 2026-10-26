//NEUROLEARN
//Purpose: To make studying and learning about neuroscience and neurodegenerative diseases fun, accessible and easy
//Target Users: High school or college students. Or anyone with an interest in the field!
//Features: 3 educational Mini games to make memorization fun, multiple study guides on neurodegenerative diseases. Also includes settings with a mode switch and accesibility features.
//Future Updates: 1) Even more cards in the card match 2) Variation in the t/f quiz 3) Multiple versions of the brain map quiz 4) More study guides on rarer/lesser researched diseases 5) New mini games


import SwiftUI
//Imported Apple's SwiftUI framework

struct GlossaryEntry: Codable, Identifiable {
    let term: String
    let definition: String

    var id: String { term }
}
//GlossaryEntry defines what each glossary item contains and makes the data compatible with JSON (import of vocabulary) and gives each entry a unique ID using its term.

enum GlossaryData {
    static func load() -> [GlossaryEntry] {
        guard let url = Bundle.main.url(
            forResource: "NeuroLearnGlossary",
            withExtension: "json"
        ) else {
            print("Could not find NeuroLearnGlossary.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(
                [GlossaryEntry].self,
                from: data
            )
        } catch {
            print("Could not load glossary: \(error)")
            return []
        }
    }
}
//GlossaryData loads the glossary terms from the NeuroLearnGlossary.json file in the app. If the file is missing or cannot be read, it will print an error message.

//Home Screen

struct ContentView: View {
    @AppStorage("neuroLearnDarkMode")
    private var darkMode = false
    
    @AppStorage("neuroLearnLargeText")
    private var largeText = false

    var body: some View {
    
        
        NavigationStack {
            ZStack {
                (
                    darkMode
                    ? Color(red: 0.08, green: 0.09, blue: 0.12)
                    : Color(red: 0.95, green: 0.97, blue: 0.99)
                )
                .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                                   NavigationLink {
                                       AppSettingsView()
                                   } label: {
                                       Image(systemName: "gearshape.fill")
                                           .font(.system(size: 22))
                                           .foregroundStyle(.secondary)
                                           .padding(10)
                                           .background(.thinMaterial, in: Circle())
                                   }
                                   .accessibilityLabel("Settings")

                                   Spacer()
                               }
                        VStack(alignment: .leading, spacing: 8) {
                            Image("")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(height: 10)
                                .padding(.bottom, 8)

                            Image("NeuroLearnLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 400)
                                .padding(.bottom, 0)
                            
                            Text("Explore the brain!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Text("Learn about neuroscience and more")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 8)

                        NavigationLink {
                            LearningMenuView()
                        } label: {
                            FeatureCard(
                                title: "Learn by Playing",
                                subtitle: "Flashcards, quizzes, and brain challenges",
                                
                                symbol: "GamesLogo",
                                color: .blue
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            StudyGuidesMenuView()
                        } label: {
                            FeatureCard(
                                title: "Study Guides",
                                subtitle: "Concise guides to diseases and neuroscience",
                                symbol: "StudyGuidesLogo",
                                color: .blue
                            )
                        }
                        .buttonStyle(.plain)


                    }
                    .padding(22)
                }
            }
            .navigationTitle("NeuroLearn")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        
        .environment(
            \.dynamicTypeSize,
            largeText ? .xxxLarge : .large
        )
    }
}

//Lines 45-144: ContentView creates NeuroLearn’s home screen, where users can open Settings navigate to learning games or study guides.

//Reusable Home Screen Card

struct FeatureCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(symbol)
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
                .frame(width: 64, height: 64)
                .background(color.opacity(0.15))
            
            VStack(alignment: .leading, spacing: 6) {
        
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 112)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

//Learn by Playing Menu

struct LearningMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Learn by Playing")
                    .font(.largeTitle.bold())

                Text("Explore the brain through interactive activities.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 14) {
                NavigationLink {
                    MatchingGameView()
                } label: {
                    activityCard(
                        title: "Brain Match",
                        subtitle: "Match concepts and definitions.",
                        icon: "square.on.square",
                        color: .blue
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    TrueFalseGameView()
                } label: {
                    activityCard(
                        title: "True or False",
                        subtitle: "Test your neuroscience knowledge.",
                        icon: "checkmark.circle",
                        color: .green
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    BrainMapGameView()
                } label: {
                    activityCard(
                        title: "Brain Map",
                        subtitle: "Identify regions of the brain.",
                        icon: "brain.head.profile",
                        color: .purple
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Study & Practice")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func activityCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack(spacing: 15) {
            
        
            if title == "Learn by Playing" {
                Image("GamesLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 58, height: 58)
                    .background(Color.white)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 58, height: 58)
            }
    

            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "arrow.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

// MARK: - Study Guides Menu


struct StudyGuidesMenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("NEURODEGENERATIVE DISEASES- MORE TO COME!")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                studyGuideButton(
                    title: "Alzheimer's Disease",
                    subtitle: "Memory, amyloid-beta, and tau",
                    icon: "brain",
                    color: .blue
                ) {
                    AlzheimersGuideView()
                }

                studyGuideButton(
                    title: "Parkinson's Disease",
                    subtitle: "Movement and dopamine",
                    icon: "figure.walk",
                    color: .green
                ) {
                    ParkinsonsGuideView()
                }

                studyGuideButton(
                    title: "ALS",
                    subtitle: "Motor neurons and muscle control",
                    icon: "waveform.path.ecg",
                    color: .orange
                ) {
                    ALSGuideView()
                }
            }
            .padding()
        }
        .navigationTitle("Study Guides")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    private func studyGuideButton<Destination: View>(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 54, height: 54)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 4)

                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(color)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

//Research Library Menu

struct ResearchMenuView: View {
    var body: some View {
        List {
            Section("Find Publications") {
                NavigationLink {
                    ActivityPlaceholderView(
                        title: "Search All Topics",
                        description: "Search scientific publications by disease, gene, or research topic."
                    )
                } label: {
                    Label(
                        "Search Publications",
                        systemImage: "magnifyingglass"
                    )
                }

                NavigationLink {
                    ActivityPlaceholderView(
                        title: "Alzheimer's Research",
                        description: "Explore published studies about Alzheimer's disease."
                    )
                } label: {
                    Label("Alzheimer's Disease", systemImage: "brain")
                }

                NavigationLink {
                    ActivityPlaceholderView(
                        title: "Parkinson's Research",
                        description: "Explore published studies about Parkinson's disease."
                    )
                } label: {
                    Label(
                        "Parkinson's Disease",
                        systemImage: "figure.walk"
                    )
                }

                NavigationLink {
                    ActivityPlaceholderView(
                        title: "Genes and Biomarkers",
                        description: "Explore research on genes, biomarkers, and disease pathways."
                    )
                } label: {
                    Label(
                        "Genes and Biomarkers",
                        systemImage: "dna"
                    )
                }
            }

            Section {
                Text(
                    "Publications will link to their original sources, such as PubMed and Europe PMC."
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Research Library")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//Temporary Content Screen

struct ActivityPlaceholderView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 54))
                .foregroundStyle(.blue)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("Learning content coming soon")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.95, green: 0.97, blue: 0.99))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}


struct MatchCard: Identifiable {
    let id = UUID()
    let pairID: Int
    let text: String
    let isTerm: Bool
}

struct MatchingGameView: View {
    @State private var cards: [MatchCard] = []
    @State private var selectedIDs: [UUID] = []
    @State private var matchedPairs: Set<Int> = []
    @State private var moves = 0
    @State private var seconds = 0
    @State private var isRunning = false
    @State private var isFinished = false
    @State private var isChecking = false
    @AppStorage("cardMatchPersonalRecord") private var personalRecord: Double = 0
    
    
    private let glossary = GlossaryData.load()
    private let pairsPerRound = 5
    
    @State private var roundPairs: [(Int, String, String)] = []
    
    
    private var timeText: String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Label(timeText, systemImage: "timer")
                    .font(.title2.bold())
                
                Spacer()
                
                Text("Moves: \(moves)")
                    .font(.headline)
            }
            
            ProgressView(
                value: Double(matchedPairs.count),
                total: Double(max(roundPairs.count, 1))
            )
            
            Text("Match each term with its definition.")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(cards) { card in
                    cardView(card)
                }
            }
            
            if isFinished {
                VStack(spacing: 10) {
                    Text("Round complete!")
                        .font(.title2.bold())
                    
                    Text("Time: \(timeText) • Moves: \(moves)")
                    
                    if personalRecord == 0 || Double(seconds) < personalRecord {
                        Text("🏆 New Personal Record!")
                            .font(.headline)
                            .foregroundStyle(.orange)
                    } else {
                        Text("Personal Best: \(Int(personalRecord)) sec")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button("Play Again") {
                        startRound()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                Button("Restart Round") {
                    startRound()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Brain Match")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if cards.isEmpty {
                startRound()
            }
        }
        .onReceive(
            Timer.publish(
                every: 1,
                on: .main,
                in: .common
            ).autoconnect()
        ) { _ in
            if isRunning && !isFinished {
                seconds += 1
            }
        }
    }
    
    private func cardView(_ card: MatchCard) -> some View {
        let isSelected = selectedIDs.contains(card.id)
        let isMatched = matchedPairs.contains(card.pairID)
        let isVisible = isSelected || isMatched
        
        return Button {
            selectCard(card)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isVisible
                    ? (card.isTerm
                       ? Color.blue.opacity(0.15)
                       : Color.purple.opacity(0.15))
                    : Color.blue
                )
                .overlay {
                    Group {
                        if isVisible {
                            Text(card.text)
                                .foregroundStyle(.primary)
                        } else {
                            Image(systemName: "brain.head.profile")
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                    }
                    .font(.subheadline.weight(.medium))
                    .multilineTextAlignment(.center)
                    .padding(10)
                }
                .frame(height: 125)
        }
        .buttonStyle(.plain)
        .disabled(
            isMatched || isSelected || isChecking || isFinished
        )
    }
    
    private func selectCard(_ card: MatchCard) {
        guard !isChecking,
              !isFinished,
              !selectedIDs.contains(card.id),
              !matchedPairs.contains(card.pairID) else {
            return
        }
        
        isRunning = true
        selectedIDs.append(card.id)
        
        guard selectedIDs.count == 2 else { return }
        
        moves += 1
        
        let chosen = cards.filter {
            selectedIDs.contains($0.id)
        }
        
        if chosen.count == 2,
           chosen[0].pairID == chosen[1].pairID,
           chosen[0].isTerm != chosen[1].isTerm {
            
            matchedPairs.insert(chosen[0].pairID)
            selectedIDs.removeAll()
            
            if matchedPairs.count == roundPairs.count {
                isFinished = true
                isRunning = false
            }
        } else {
            isChecking = true
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.9
            ) {
                selectedIDs.removeAll()
                isChecking = false
            }
        }
    }
    
    private func startRound() {
        let selectedEntries = Array(
            glossary.shuffled().prefix(
                min(pairsPerRound, glossary.count)
            )
        )
        
        roundPairs = selectedEntries.enumerated().map {
            index, entry in
            (index, entry.term, entry.definition)
        }
        
        cards = roundPairs.flatMap { pair in
            [
                MatchCard(
                    pairID: pair.0,
                    text: pair.1,
                    isTerm: true
                ),
                MatchCard(
                    pairID: pair.0,
                    text: pair.2,
                    isTerm: false
                )
            ]
        }.shuffled()
        
        selectedIDs.removeAll()
        matchedPairs.removeAll()
        moves = 0
        seconds = 0
        isRunning = false
        isFinished = false
        isChecking = false
    }
    
}
    
    
    
    // True / False Quiz Question
    
    struct QuizQuestion: Identifiable {
        let id = UUID()
        let statement: String
        let answer: Bool
        let explanation: String
    }
    
    // True / False Game
    
    struct TrueFalseGameView: View {
        
        private let questions: [QuizQuestion] = [
            QuizQuestion(
                statement: "The hippocampus plays an important role in forming new memories.",
                answer: true,
                explanation: "The hippocampus is important for forming new memories and learning."
            ),
            QuizQuestion(
                statement: "The occipital lobe primarily processes sound.",
                answer: false,
                explanation: "The occipital lobe is primarily involved in processing visual information."
            ),
            QuizQuestion(
                statement: "Parkinson's disease is associated with changes in dopamine-producing neurons.",
                answer: true,
                explanation: "Parkinson's disease involves the loss or dysfunction of dopamine-producing neurons, particularly in the substantia nigra."
            ),
            QuizQuestion(
                statement: "The cerebellum helps coordinate movement and balance.",
                answer: true,
                explanation: "The cerebellum contributes to coordination, balance, and motor learning."
            ),
            QuizQuestion(
                statement: "Neurons communicate only through direct physical contact.",
                answer: false,
                explanation: "Neurons can communicate across synapses using chemical neurotransmitters or electrical signals."
            ),
            QuizQuestion(
                statement: "Myelin can help electrical signals travel faster along many nerve fibers.",
                answer: true,
                explanation: "Myelin insulates many axons and supports faster signal conduction."
            ),
            QuizQuestion(
                statement: "Alzheimer's disease can affect memory and thinking.",
                answer: true,
                explanation: "Alzheimer's disease is a brain disorder that progressively affects memory and other cognitive abilities."
            ),
            QuizQuestion(
                statement: "The frontal lobe has no role in planning or decision-making.",
                answer: false,
                explanation: "Parts of the frontal lobe contribute to planning, decision-making, and other executive functions."
            )
        ]
        
        @State private var questionOrder: [Int] = []
        @State private var currentIndex = 0
        @State private var score = 0
        @State private var selectedAnswer: Bool? = nil
        @State private var isFinished = false
        
        private var currentQuestion: QuizQuestion {
            questions[questionOrder[currentIndex]]
        }
        
        var body: some View {
            VStack(spacing: 24) {
                
                if isFinished {
                    completionScreen
                } else if !questionOrder.isEmpty {
                    quizScreen
                }
                
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(red: 0.95, green: 0.97, blue: 0.99)
                    .ignoresSafeArea()
            )
            .navigationTitle("Knowledge Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if questionOrder.isEmpty {
                    startQuiz()
                }
            }
        }
        
        private var quizScreen: some View {
            VStack(spacing: 24) {
                
                HStack {
                    Text("Question \(currentIndex + 1) of \(questions.count)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Label("\(score)", systemImage: "star.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
                
                ProgressView(
                    value: Double(currentIndex + 1),
                    total: Double(questions.count)
                )
                .tint(.blue)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 55))
                    .foregroundStyle(.blue)
                
                Text(currentQuestion.statement)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                VStack(spacing: 14) {
                    answerButton("True", answer: true)
                    answerButton("False", answer: false)
                }
                
                if let selectedAnswer {
                    feedbackView(selectedAnswer)
                }
                
                Button(
                    currentIndex == questions.count - 1
                    ? "See Results"
                    : "Next Question"
                ) {
                    goToNextQuestion()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedAnswer == nil)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
        
        private func answerButton(
            _ title: String,
            answer: Bool
        ) -> some View {
            Button {
                guard selectedAnswer == nil else { return }
                
                selectedAnswer = answer
                
                if answer == currentQuestion.answer {
                    score += 1
                }
            } label: {
                Text(title)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(buttonColor(for: answer))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            .disabled(selectedAnswer != nil)
        }
        
        private func buttonColor(for answer: Bool) -> Color {
            guard let selectedAnswer else {
                return .white
            }
            
            if answer == currentQuestion.answer {
                return .green.opacity(0.25)
            }
            
            if answer == selectedAnswer {
                return .red.opacity(0.2)
            }
            
            return .white
        }
        
        private func feedbackView(_ answer: Bool) -> some View {
            VStack(spacing: 8) {
                Text(
                    answer == currentQuestion.answer
                    ? "Correct!"
                    : "Not quite!"
                )
                .font(.headline)
                
                Text(currentQuestion.explanation)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
        private var completionScreen: some View {
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Quiz Complete!")
                    .font(.largeTitle.bold())
                
                Text("You scored \(score) out of \(questions.count).")
                    .font(.title3)
                
                Text(resultMessage)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Button("Play Again") {
                    startQuiz()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        
        private var resultMessage: String {
            if score == questions.count {
                return "Perfect score! Excellent neuroscience knowledge."
            } else if score >= questions.count / 2 {
                return "Nice work! Keep learning and try again."
            } else {
                return "Good effort! Review the explanations and try again."
            }
        }
        
        private func goToNextQuestion() {
            if currentIndex + 1 < questions.count {
                currentIndex += 1
                selectedAnswer = nil
            } else {
                isFinished = true
            }
        }
        
        private func startQuiz() {
            questionOrder = Array(questions.indices).shuffled()
            currentIndex = 0
            score = 0
            selectedAnswer = nil
            isFinished = false
        }
    }
    

struct BrainMapGameView: View {

    private let imageWidth: CGFloat = 1423
    private let imageHeight: CGFloat = 2048

    private struct BrainRegion: Identifiable {
        let id: Int
        let name: String
        let rgb: (Int, Int, Int)

        var identifiableColor: Color {
            Color(
                .sRGB,
                red: Double(rgb.0) / 255,
                green: Double(rgb.1) / 255,
                blue: Double(rgb.2) / 255,
                opacity: 1
            )
        }
    }

    private let regions: [BrainRegion] = [
        .init(id: 0, name: "Higher mental functions", rgb: (255, 0, 0)),
        .init(id: 1, name: "Motor function area", rgb: (0, 255, 0)),
        .init(id: 2, name: "Broca's area", rgb: (0, 0, 255)),
        .init(id: 3, name: "Motor function area", rgb: (255, 255, 0)),
        .init(id: 4, name: "Sensory area", rgb: (255, 0, 255)),
        .init(id: 5, name: "Brainstem", rgb: (0, 255, 255)),
        .init(id: 6, name: "Association area", rgb: (255, 128, 0)),
        .init(id: 7, name: "Auditory area", rgb: (128, 0, 255)),
        .init(id: 8, name: "Wernicke's area", rgb: (128, 255, 0)),
        .init(id: 9, name: "Somatosensory association area", rgb: (0, 128, 255)),
        .init(id: 10, name: "Visual area", rgb: (255, 0, 128)),
        .init(id: 11, name: "Motor functions", rgb: (128, 128, 0))
    ]

    @State private var questionOrder = Array(0..<12).shuffled()
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var answered = false
    @State private var selectedRegionID: Int? = nil
    @State private var finished = false
    @State private var feedback = ""

    private var currentRegion: BrainRegion {
        regions[questionOrder[currentIndex]]
    }

    var body: some View {
        VStack(spacing: 12) {

            if finished {
                VStack(spacing: 20) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 55))
                        .foregroundStyle(.blue)

                    Text("Brain Map Complete!")
                        .font(.title.bold())

                    Text("You scored \(score) out of \(regions.count).")
                        .font(.title3)

                    Button("Play Again") {
                        startGame()
                    }
                    .buttonStyle(.borderedProminent)
                }

            } else {
                Text("Question \(currentIndex + 1) of \(regions.count)")
                    .font(.headline)

                ProgressView(
                    value: Double(currentIndex + 1),
                    total: Double(regions.count)
                )

                Text("Find the \(currentRegion.name).")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("Tap the matching colored region.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                GeometryReader { geometry in

                    let fittedWidth = min(
                        geometry.size.width,
                        geometry.size.height * imageWidth / imageHeight
                    )

                    let fittedHeight =
                        fittedWidth * imageHeight / imageWidth

                    let left =
                        (geometry.size.width - fittedWidth) / 2

                    let top =
                        (geometry.size.height - fittedHeight) / 2

                    ZStack {
                        Image("BrainFunctionalAreas")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: fittedWidth,
                                height: fittedHeight
                            )
                            .position(
                                x: geometry.size.width / 2,
                                y: geometry.size.height / 2
                            )

                        // Make only the selected region appear pale.
                        if let selectedID = selectedRegionID {
                            Image("BrainFunctionalAreasMask")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: fittedWidth,
                                    height: fittedHeight
                                )
                                .colorMultiply(
                                    regions[selectedID].identifiableColor
                                )
                                .overlay {
                                    Color.white.opacity(0.5)
                                }
                                .blendMode(.screen)
                                .frame(
                                    width: fittedWidth,
                                    height: fittedHeight
                                )
                                .position(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )
                                .allowsHitTesting(false)
                            }

                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        guard !answered else {
                                            return
                                        }

                                        let x = value.location.x - left
                                        let y = value.location.y - top

                                        guard
                                            x >= 0,
                                            x < fittedWidth,
                                            y >= 0,
                                            y < fittedHeight
                                        else {
                                            return
                                        }

                                        let pixelX = Int(
                                            x / fittedWidth * imageWidth
                                        )

                                        let pixelY = Int(
                                            y / fittedHeight * imageHeight
                                        )

                                        if let regionID = regionAt(
                                            x: pixelX,
                                            y: pixelY
                                        ) {
                                            selectRegion(regionID)
                                        } else {
                                            feedback =
                                                "Tap inside a colored brain area."
                                        }
                                    }
                            )
                            .allowsHitTesting(!answered)
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                }
                .frame(maxHeight: 420)

                Text(feedback)
                    .font(.subheadline.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        feedback == "Correct!" ? .green : .primary
                    )
                    .frame(minHeight: 38)

                if !answered {
                    Button("Check Answer") {
                        guard let selectedRegionID else {
                            feedback = "Please select a brain region first."
                            return
                        }

                        answered = true

                        if selectedRegionID == currentRegion.id {
                            score += 1
                            feedback = "Correct!"
                        } else {
                            feedback =
                                "Not quite! The answer is \(currentRegion.name)."
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedRegionID == nil)
                }

                if answered {
                    Button(
                        currentIndex == regions.count - 1
                            ? "See Results"
                            : "Next Question"
                    ) {
                        nextQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .navigationTitle("Brain Map Match")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func regionAt(x: Int, y: Int) -> Int? {
        guard
            let image = UIImage(
                named: "BrainFunctionalAreasMask"
            )?.cgImage,
            let provider = image.dataProvider,
            let data = provider.data,
            let bytes = CFDataGetBytePtr(data)
        else {
            return nil
        }

        guard
            x >= 0, x < image.width,
            y >= 0, y < image.height,
            image.bitsPerPixel == 32
        else {
            return nil
        }

        let offset = y * image.bytesPerRow + x * 4

        let red = Int(bytes[offset])
        let green = Int(bytes[offset + 1])
        let blue = Int(bytes[offset + 2])
        let alpha = Int(bytes[offset + 3])

        guard alpha > 0 else {
            return nil
        }

        return regions.first {
            $0.rgb.0 == red &&
            $0.rgb.1 == green &&
            $0.rgb.2 == blue
        }?.id
    }

    private func selectRegion(_ id: Int) {
        guard !answered else {
            return
        }

        selectedRegionID = id
        feedback = "Region selected. Tap Check Answer."
    }

    private func nextQuestion() {
        if currentIndex + 1 < regions.count {
            currentIndex += 1
            answered = false
            selectedRegionID = nil
            feedback = ""
        } else {
            finished = true
        }
    }

    private func startGame() {
        selectedRegionID = nil
        questionOrder = Array(0..<regions.count).shuffled()
        currentIndex = 0
        score = 0
        answered = false
        finished = false
        feedback = ""
    }
}



struct DiseaseNotesView: View {
    let diseaseName: String
    let subtitle: String
    let sections: [(title: String, content: String)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 42))
                        .foregroundStyle(.blue)

                    Text(diseaseName)
                        .font(.largeTitle.bold())

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                ForEach(sections.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(sections[index].title)
                            .font(.title3.bold())

                        Text(sections[index].content)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding()
                    .background(
                        Color(.secondarySystemGroupedBackground)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(diseaseName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlzheimersGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Alzheimer’s Disease")
                    .font(.largeTitle.bold())

                Group {
                    Text("Overview")
                        .font(.title2.bold())

                    Text("""
                    Alzheimer’s disease is a progressive brain disorder and the most common cause of dementia. It gradually affects memory, thinking, language, judgment, and everyday activities. Brain changes may begin years before symptoms appear.

                    Two major features are beta-amyloid plaques, which form between neurons, and tau tangles, which develop inside neurons. These changes contribute to brain-cell dysfunction and loss of connections between brain cells.
                    """)
                }

                Group {
                    Text("Common Symptoms During Stages")
                        .font(.title2.bold())

                    Text("Early Stage (Mild)")
                        .font(.headline)
                    Text("""
                    • Forgetting recent events or conversations
                    • Repeating questions or misplacing items
                    • Difficulty planning, organizing, or managing money
                    • Trouble finding words
                    • Getting lost in familiar places
                    """)

                    Text("Middle Stage (Moderate)")
                        .font(.headline)
                    Text("""
                    • Increasing memory loss and confusion
                    • Difficulty reading, writing, or completing familiar tasks
                    • Changes in sleep, mood, or behavior
                    • Difficulty recognizing familiar people
                    • Increased need for assistance with daily activities
                    """)

                    Text("Late Stage (Severe)")
                        .font(.headline)
                    Text("""
                    • Major difficulty communicating
                    • Difficulty recognizing surroundings or loved ones
                    • Requiring extensive help with personal care
                    • Difficulty walking, eating, or swallowing
                    """)

                    Text("Progression varies from person to person, and not everyone experiences the same symptoms.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Group {
                    Text("Studied and Potential Causes")
                        .font(.title2.bold())

                    Text("""
                    There is no single known cause for most cases of Alzheimer’s disease. Risk involves a combination of aging, genetics, health, and environmental or lifestyle factors.

                    • Beta-amyloid and tau: Abnormal protein accumulation is associated with damage to brain cells.
                    • Genetics: The APOE ε4 variant increases risk. Rare inherited variants in APP, PSEN1, and PSEN2 can cause some familial cases.
                    • Vascular health: Conditions affecting blood vessels may contribute to cognitive decline.
                    • Inflammation and metabolism: Researchers study how inflammation and impaired cellular energy production contribute to disease.
                    • Sleep and lifestyle: Researchers are investigating how sleep, physical activity, and other health factors influence risk.
                    """)
                }

                Group {
                    Text("Diagnosis, Treatment, and Research")
                        .font(.title2.bold())

                    Text("""
                    Diagnosis may involve medical history, cognitive assessments, brain imaging, and biomarker tests. There is currently no cure, but medications and supportive care can help manage symptoms. Certain approved treatments can slow decline in eligible patients.

                    Researchers are investigating earlier diagnosis, prevention, and treatments targeting the underlying biological processes.
                    """)
                }
            }
            .padding(20)
        }
        .navigationTitle("Alzheimer’s Disease")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Parkinson's Disease Study Guide

struct ParkinsonsGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Parkinson's Disease")
                    .font(.largeTitle.bold())

                Group {
                    Text("Overview")
                        .font(.title2.bold())

                    Text("""
                    Parkinson’s disease is a progressive nervous-system disorder that primarily affects movement. Many symptoms are associated with the loss or dysfunction of dopamine-producing neurons in a brain region called the substantia nigra. Dopamine is a chemical messenger that helps coordinate smooth movement. Parkinson’s disease can also affect sleep, mood, digestion, blood pressure, and thinking.
                    """)
                }

                Divider()

                Group {
                    Text("Common Symptoms During Stages")
                        .font(.title2.bold())

                    Text("Early Stage")
                        .font(.headline)

                    Text("""
                    • Tremor, often beginning in one hand
                    • Muscle stiffness
                    • Slower movement
                    • Smaller handwriting
                    • Reduced arm swing or a softer voice
                    • Constipation, sleep changes, or reduced sense of smell
                    """)

                    Text("Middle Stage")
                        .font(.headline)

                    Text("""
                    • Increasing stiffness and slowness
                    • Shuffling while walking
                    • Difficulty completing everyday tasks
                    • Balance problems and increased risk of falls
                    • Episodes of freezing while walking
                    • Changes in speech and facial expression
                    """)

                    Text("Advanced Stage")
                        .font(.headline)

                    Text("""
                    • Significant difficulty with mobility
                    • Greater need for help with daily activities
                    • Difficulty swallowing
                    • Blood-pressure and sleep problems
                    • Possible cognitive changes
                    """)

                    Text("Symptoms and progression vary. Not everyone with Parkinson’s disease develops a tremor or experiences every symptom.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Divider()

                Group {
                    Text("Studied and Potential Causes")
                        .font(.title2.bold())

                    Text("""
                    The exact cause is unknown in most cases. Researchers believe Parkinson’s disease results from a combination of genetic susceptibility, aging, and environmental influences.
                    """)

                    Text("""
                    • Dopamine-producing neuron loss: Reduced dopamine disrupts movement control.
                    • Genetics: Variants in genes such as LRRK2 and GBA1 are associated with increased risk.
                    • Alpha-synuclein: Clumps of this protein, called Lewy bodies, are associated with the disease.
                    • Environmental exposures: Certain pesticide and pollutant exposures have been associated with increased risk.
                    • Mitochondrial dysfunction: Researchers study how impaired cellular energy production may contribute to neuron damage.
                    • Cellular stress: Researchers investigate inflammation and problems with normal cell-maintenance processes.
                    """)
                }

                Divider()

                Group {
                    Text("Diagnosis, Treatment, and Research")
                        .font(.title2.bold())

                    Text("""
                    Diagnosis is based primarily on medical history and neurological examination. There is no single test that confirms every case. Medications such as levodopa can improve many movement symptoms. Physical, occupational, and speech therapy may help maintain independence, while some people benefit from deep-brain stimulation.
                    """)

                    Text("""
                    Current treatments manage symptoms but do not cure the disease. Research focuses on identifying causes and developing treatments that slow progression.
                    """)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Parkinson's Disease")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct ALSGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Amyotrophic Lateral Sclerosis (ALS)")
                    .font(.largeTitle.bold())

                Group {
                    Text("Overview")
                        .font(.title2.bold())

                    Text("""
                    Amyotrophic lateral sclerosis (ALS), sometimes called Lou Gehrig’s disease, is a progressive neurodegenerative disorder that damages motor neurons in the brain and spinal cord. Motor neurons control voluntary muscles used for walking, speaking, swallowing, and breathing. As these nerve cells stop functioning, muscles become weaker. ALS primarily affects movement, although some people also experience changes in behavior, language, or cognition.
                    """)
                }

                Group {
                    Text("Common Symptoms During Stages")
                        .font(.title2.bold())

                    Text("Early Stage")
                        .font(.headline)

                    Text("""
                    • Weakness in a hand, arm, foot, or leg
                    • Tripping or difficulty walking
                    • Difficulty with fine-motor tasks
                    • Muscle cramps or twitching
                    • Muscle stiffness
                    • Slurred speech or difficulty swallowing in some cases
                    """)

                    Text("Progressing Disease")
                        .font(.headline)

                    Text("""
                    • Weakness spreading to additional muscle groups
                    • Increasing difficulty walking or using the hands
                    • Difficulty speaking, chewing, or swallowing
                    • Fatigue and possible weight loss
                    • Greater need for assistance with daily activities
                    """)

                    Text("Advanced Stage")
                        .font(.headline)

                    Text("""
                    • Major mobility limitations
                    • Difficulty communicating
                    • Increased difficulty eating and swallowing
                    • Weakening respiratory muscles, making breathing more difficult
                    • Need for additional respiratory and daily-living support
                    """)

                    Text("""
                    The rate and pattern of progression vary considerably among individuals.
                    """)
                    .foregroundStyle(.secondary)
                }

                Group {
                    Text("Studied and Potential Causes")
                        .font(.title2.bold())

                    Text("""
                    Most ALS cases are sporadic, meaning there is no clear family history. A smaller proportion are familial and associated with inherited genetic variants. The exact causes of many cases remain unknown.
                    """)

                    Text("""
                    • Genetics: Variants in genes such as C9orf72, SOD1, TARDBP, and FUS are associated with some cases.

                    • Protein aggregation: Abnormal protein accumulation may interfere with normal neuron function.

                    • RNA processing: Researchers investigate how disruptions in processing genetic instructions affect motor neurons.

                    • Mitochondrial dysfunction: Problems with cellular energy production may contribute to neuron damage.

                    • Oxidative stress: Damage associated with reactive molecules may play a role.

                    • Environmental factors: Researchers are investigating how environmental exposures might interact with genetic susceptibility.
                    """)

                    Text("No single mechanism explains every case of ALS.")
                        .foregroundStyle(.secondary)
                }

                Group {
                    Text("Diagnosis, Treatment, and Research")
                        .font(.title2.bold())

                    Text("""
                    Diagnosis involves neurological examinations and tests to help rule out other conditions. There is no single test that detects every case. Although there is currently no cure, approved medications may slow aspects of progression for some people or help manage symptoms.

                    Multidisciplinary care—including respiratory, nutritional, physical, occupational, and speech support—can improve quality of life.

                    Research focuses on protecting motor neurons, understanding genetic subtypes, improving early diagnosis, and developing new treatments.
                    """)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("ALS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppSettingsView: View {
    @AppStorage("neuroLearnDarkMode")
    private var darkMode = false

    @AppStorage("neuroLearnLargeText")
    private var largeText = false

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle(isOn: $darkMode) {
                    Label("Dark Mode", systemImage: "moon.stars.fill")
                }

                Toggle(isOn: $largeText) {
                    Label("Larger Text", systemImage: "textformat.size")
                }

                Text("Your preferences are saved automatically.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

        
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}


