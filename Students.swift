//
//  Students.swift
//
//  Created by Layla Michel
//  Created on 2022-05-05
//  Version 1.0
//  Copyright (c) 2022 IMH. All rights reserved.
//
//  This program creates reads from a file containing information about
// different students, checks for the validity of the information and
// creates an object containing that information.

import Foundation

class Students {
    // Properties
    private var firstName: String
    private var middleInit: String
    private var lastName: String
    private var grade: String
    private var iep: String
    private var strArray: [String] = ["0", "0", "0", "0", "0"]

    // Constructor
    init(forename: String, midInitial: String, surname: String, schoolGrade: String, iepBool: String) {
        firstName = forename
        middleInit = midInitial
        lastName = surname
        grade = schoolGrade
        iep = iepBool
    }

    func prints() {
        // Adding student's information to an array
        strArray[0] = "First name: \(firstName)"
        strArray[1] = "Middle initial: \(middleInit)"
        strArray[2] = "Last name: \(lastName)"
        strArray[3] = "Grade: \(grade)"
        strArray[4] = "Student has an IEP? \(iep)"

        // Create string containing elements of the array
        // separated by a new line
        let joined = strArray.joined(separator: "\n")
        let newLine = "\n"

        // Path to the output file
        let saveToPath = URL(string: "/home/runner/Unit3-05-Swift/output.txt")

        do {
            // Code from: 
            // https://stackoverflow.com/questions/27327067/
            // append-text-or-data-to-text-file-in-swift
            if let fileUpdater = try? FileHandle(forUpdating: saveToPath!) {

                // Function which when called will cause all updates
                // to start from end of the file
                fileUpdater.seekToEndOfFile()

                // Which lets the caller move editing to any position within
                // the file by supplying an offset
                fileUpdater.write(joined.data(using: .utf8)!)
                fileUpdater.write(newLine.data(using: .utf8)!)
                fileUpdater.write(newLine.data(using: .utf8)!)

                // Once we convert our new content to data and write it,
                // we close the file and that’s it!
                fileUpdater.closeFile()
            }
        }
        print("Results added to 'output.txt'")
    }
}

var counter = 0

do {
    if CommandLine.argc < 2 {
        // Error message if no file is inputted
        print("Error: Text file needed.")
    } else {
        // Read command line arguments for file name
        let arguments = CommandLine.arguments
        let file: String = arguments[1]

        let set = try String(contentsOfFile: file, encoding: String.Encoding.utf8)
        // Create array of the elements in the text file
        let stringArray: [String] = set.components(separatedBy: "\n")

        for student in stringArray {
            // Create list of each element of the array
            var list = student.components(separatedBy: " ")

            var counter2 = 0

            for string in list {
                // Check if counter2 is at the grade index
                if counter2 == 3 {
                    // Check if string at that index is an integer
                    let stringInt = Int(string) ?? -23847125624345235

                    if stringInt == -23847125624345235 {
                        // Set element to null if it is not an integer
                        list[counter2] = "null"
                    } else if stringInt < 9 || stringInt > 12 {
                        // Set element to null if it is not within the valid
                        // range
                        list[counter2] = "null"
                    }
                // Check if counter2 is at the true or false index
                } else if counter2 == 4 {
                    if string.uppercased != "TRUE" && string.uppercased != "FALSE" {
                        // Set element to null if is not true or false
                        list[counter2] = "null"
                    }
                }
                counter2 += 1
            }
            // Create aStudent object containing the information of each string
            let aStudent = Students(forename: list[0],
                midInitial: list[1],
                surname: list[2],
                schoolGrade: list[3],
                iepBool: list[4])

            // Call prints method to display the information in a separate file
            aStudent.prints()

            counter += 1
        }
    }
} catch {
    // Error message if nonexistent file is inputted
    print("File does not exist.")
}
