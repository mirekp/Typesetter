//
//  TypesetterTests.swift
//  TypesetterTests
//
//  Created by Beat Richartz on 30/01/2016.
//  Copyright © 2016 Beat Richartz. All rights reserved.
//

import XCTest
import Nimble

import Typesetter

class TypesetterTests: XCTestCase {
    
    enum Font: String, TypesetterFont {
        case Regular = "Georgia"
        case Bold = "Courier"
        
        var name: String {
            return rawValue
        }
    }
    
    var typesetter: Typesetter!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        guard let csvPath = NSBundle(forClass: self.dynamicType).pathForResource("FontSizes", ofType: "csv") else {
            fail("Font fixture file TypesetterFontSizes.csv is missing")
            return
        }
        
        typesetter = Typesetter(
            configuration: TypesetterConfiguration(sizeDefinitionsPath: csvPath)
        )
    }
    
    override func tearDown() {
        typesetter = nil
        super.tearDown()
    }
    
    func testConvenienceInit() {
        let convenienceTypesetter = Typesetter(bundle: NSBundle(forClass: self.dynamicType))
        expect(convenienceTypesetter.hasSizes).to(beTrue())
    }
    
    func testConvenienceInitWithNoPath() {
        let convenienceTypesetter = Typesetter(bundle: NSBundle())
        expect(convenienceTypesetter.hasSizes).to(beFalse())
    }
    
    func testFontForWithoutSizes() {
        typesetter = Typesetter(bundle: NSBundle())
        let font = typesetter.sizedFontFor(.Body, font: Font.Bold)
        expect(font.pointSize).to(equal(12.0))
    }
    
    func testConvenienceInitPerformance() {
        self.measureBlock {
            for _ in 1..<10000 {
                let _ = Typesetter(bundle: NSBundle(forClass: self.dynamicType))
            }
        }
    }
    
    func testFontFor() {
        let font = typesetter.sizedFontFor(.Subheadline, font: Font.Regular)
        expect(font.pointSize).to(equal(11.0))
        expect(font.fontName).to(equal(Font.Regular.name))
        expect(font.familyName).to(equal("Georgia"))
    }
    
    func testFontForWithDifferentCut() {
        let font = typesetter.sizedFontFor(TypesetterTextStyle.Headline.rawValue, font: Font.Bold)
        expect(font.pointSize).to(equal(15.0))
        expect(font.fontName).to(equal(Font.Bold.name))
        expect(font.familyName).to(equal("Courier"))
    }
    
    func testFontForWithInvalidValue() {
        let font = typesetter.sizedFontFor("Garbage", font: Font.Regular)
        expect(font.pointSize).to(equal(11.0))
        expect(font.fontName).to(equal(Font.Regular.name))
        expect(font.familyName).to(equal("Georgia"))
    }
    
}
