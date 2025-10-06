//
//  FAQView.swift
//  Asana
//
//  Created by Kiran T C on 06/10/25.
//

import SwiftUI

struct FAQView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let faqs: [(question: String, answer: String)] = [
        ("What Should I Wear For Yoga?",
         "Wear comfortable, stretchable, and breathable clothes. Avoid tight jeans or restrictive outfits. Yoga-specific leggings or shorts and a light top are perfect."),
        
        ("Do I Need Any Equipment To Start Yoga?",
         "All you need to begin is a yoga mat. Over time, you can add props like blocks, straps, or cushions for comfort and better alignment."),
        
        ("How Long Should I Practice Yoga Each Day?",
         "Even 20 to 30 minutes daily can be effective. The key is consistency. Gradually increase duration as your stamina and focus improve."),
        
        ("Can Beginners Practice Yoga Safely?",
         "Yes! Start with beginner-friendly poses and focus on proper form rather than flexibility. Listen to your body and avoid pushing through pain."),
        
        ("Is It Okay To Do Yoga On A Full Stomach?",
         "It’s best to practice yoga on an empty or light stomach. Wait at least 2–3 hours after a heavy meal before doing yoga."),
        
        ("How Does Yoga Help With Back And Neck Pain?",
         "Yoga strengthens your core and improves posture, which can relieve pressure on your spine and neck. Gentle stretches also reduce stiffness."),
        
        ("What If I’m Not Flexible Enough For Yoga?",
         "Flexibility develops with time. Yoga is about progress, not perfection. Focus on breathing and alignment, and your flexibility will naturally improve."),
        
        ("Can I Practice Yoga If I Have An Injury?",
         "Yes, but consult your doctor first. Avoid poses that strain your injured area and modify movements as needed with the help of a teacher."),
        
        ("Can I Drink Water During Or Before Yoga?",
         "It’s okay to drink small sips before class, but avoid drinking large amounts during practice. Stay hydrated before and after yoga."),
        
        ("Can I Do Yoga While Having A Stomach Ache Or Headache?",
         "Avoid yoga if you’re feeling unwell. Rest and resume your practice once you feel better to prevent worsening symptoms.")
    ]
    
    @State private var expandedIndex: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.98, blue: 0.97)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(faqs.indices, id: \.self) { index in
                            FAQCard(
                                question: faqs[index].question,
                                answer: faqs[index].answer,
                                isExpanded: expandedIndex == index
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    expandedIndex = expandedIndex == index ? nil : index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
            .background(Color(hex: "#EAF2F2").ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Centered bold orange title like the 2nd screenshot
                ToolbarItem(placement: .principal) {
                    Text("FAQs")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: "#EB784E"))
                }

                // Optional menu button on the right
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
            }
            
            }
        }
    }
}

struct FAQCard: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(question)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.orange.opacity(0.4), lineWidth: 1)
        )
    }
}
