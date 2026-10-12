import Foundation

let auth = AuthManager()
auth.login(email: "owner@example.test", password: "demo", role: .business)
let owner = auth.currentUser!
auth.logout()
auth.login(email: " OWNER@example.test ", password: "demo", role: .business)
precondition(auth.currentUser!.id == owner.id)
let other = User(email: "other@example.test", name: "Other", role: .business, location: "UB")
let creator = User(email: "creator@example.test", name: "Creator", role: .influencer, location: "UB")
let store = DataStore()
var offer = store.offers[0]
offer.id = UUID(); offer.businessId = owner.id
precondition(store.addOffer(offer, business: owner))
precondition(!store.addOffer(offer, business: owner))
precondition(!store.addOffer(offer, business: creator))
precondition(store.offers(forBusiness: owner.id).map(\.id) == [offer.id])
precondition(store.offers(forBusiness: other.id).isEmpty)
precondition(store.applyToOffer(offerId: offer.id, influencerId: creator.id, name: creator.name, handle: "@creator", followers: 5000, message: "Interested"))
precondition(!store.applyToOffer(offerId: offer.id, influencerId: creator.id, name: creator.name, handle: "@creator", followers: 5000, message: "Duplicate"))
precondition(store.applications(forBusiness: owner.id).count == 1)
precondition(store.applications(forBusiness: other.id).isEmpty)
precondition(store.applications(forInfluencer: creator.id).count == 1)
precondition(store.applications(forInfluencer: UUID()).isEmpty)
let count = store.applications.count
precondition(!store.applyToOffer(offerId: offer.id, influencerId: UUID(), name: "New", handle: "@new", followers: 1, message: "Below minimum"))
precondition(store.applications.count == count)
offer.id = UUID(); offer.deadline = Date().addingTimeInterval(-60)
precondition(!store.addOffer(offer, business: owner))
print("Marketplace ownership and application checks passed")
