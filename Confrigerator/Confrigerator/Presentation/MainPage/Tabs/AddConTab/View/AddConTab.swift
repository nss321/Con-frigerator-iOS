//
//  AddConTab.swift
//  Confrigerator
//
//  Created by BAE on 5/1/24.
//

import SwiftUI

struct AddConTab: View {

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("이미지로 기프티콘을 추가합니다.")) {
                        NavigationLink {
                            AddConUsingImage()
                        } label: {
                            Text("이미지로 추가")
                        }
                        
                    }
                    Section(header: Text("일련번호로 기프티콘을 추가합니다.")) {
                        NavigationLink {
                            AddConUsingSerialNumber()
                        } label: {
                            Text("일련번호로 추가")
                        }
                    }
                }
            }
            .navigationTitle("콘 등록하기")
        }
    }
    
}
